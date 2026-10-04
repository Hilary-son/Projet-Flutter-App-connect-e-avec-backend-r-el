import 'package:dio/dio.dart';
import '../constants.dart';
import '../storage/token_storage.dart';

/// 1) Injecte le token dans chaque requête.
/// 2) Sur 401 : tente un refresh, puis rejoue la requête.
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this._tokens, {this.onSessionExpired});

  final TokenStorage _tokens;
  final void Function()? onSessionExpired;

  // Dio "nu" (sans intercepteur) : évite les boucles infinies.
  final Dio _plainDio = Dio(BaseOptions(baseUrl: Constants.baseUrl));

  bool _isAuthEndpoint(String path) =>
      path == Constants.loginPath || path == Constants.refreshPath;

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    if (!_isAuthEndpoint(options.path)) {
      final token = await _tokens.access;
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final is401 = err.response?.statusCode == 401;
    if (!is401 || _isAuthEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    final refresh = await _tokens.refresh;
    if (refresh == null) return handler.next(err);

    String newAccess;
    try {
      final res = await _plainDio.post(Constants.refreshPath, data: {
        'refreshToken': refresh,
        'expiresInMins': 30,
      });
      newAccess = res.data['accessToken'] as String;
      await _tokens.save(
          access: newAccess, refresh: res.data['refreshToken'] as String);
    } catch (_) {
      await _tokens.clear();
      onSessionExpired?.call();
      return handler.next(err);
    }

    try {
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccess';
      handler.resolve(await _plainDio.fetch(opts));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
