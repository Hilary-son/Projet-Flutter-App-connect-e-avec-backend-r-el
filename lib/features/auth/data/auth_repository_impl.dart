import 'package:dio/dio.dart';
import '../../../core/constants.dart';
import '../../../core/data/cached_fetcher.dart';
import '../../../core/error/failures.dart';
import '../../../core/storage/cache_service.dart';
import '../../../core/storage/token_storage.dart';
import '../domain/auth_repository.dart';
import '../domain/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio, this._tokens, this._cache);
  final Dio _dio;
  final TokenStorage _tokens;
  final CacheService _cache;

  static const userCacheKey = 'user';

  @override
  Future<bool> hasSession() async => (await _tokens.access) != null;

  @override
  Future<User> login(String username, String password) async {
    try {
      final res = await _dio.post<dynamic>(Constants.loginPath, data: {
        'username': username,
        'password': password,
        'expiresInMins': 30,
      });
      await _tokens.save(
        access: res.data['accessToken'] as String,
        refresh: res.data['refreshToken'] as String,
      );
      final user = User.fromJson(Map<String, dynamic>.from(res.data as Map));
      await _cache.saveMap(userCacheKey, user.toJson());
      return user;
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  /// DummyJSON simule la création : rien n'est réellement enregistré.
  @override
  Future<User> register({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<dynamic>('/users/add', data: {
        'firstName': firstName,
        'lastName': lastName,
        'username': username,
        'email': email,
        'password': password,
      });
      return User.fromJson(Map<String, dynamic>.from(res.data as Map));
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  @override
  Future<DataResult<User>> getCurrentUser() async {
    try {
      final res = await _dio.get<dynamic>(Constants.mePath);
      final user = User.fromJson(Map<String, dynamic>.from(res.data as Map));
      await _cache.saveMap(userCacheKey, user.toJson());
      return DataResult(user);
    } on DioException catch (e) {
      final cached = _cache.readMap(userCacheKey);
      if (cached != null) {
        return DataResult(User.fromJson(cached), fromCache: true);
      }
      throw mapDioError(e);
    }
  }

  @override
  Future<void> logout() async {
    await _tokens.clear();
    await _cache.clear();
  }
}
