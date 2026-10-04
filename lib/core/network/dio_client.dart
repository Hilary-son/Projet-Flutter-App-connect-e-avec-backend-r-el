import 'package:dio/dio.dart';
import '../constants.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

Dio createDio(TokenStorage tokens, {void Function()? onSessionExpired}) {
  final dio = Dio(BaseOptions(
    baseUrl: Constants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));
  dio.interceptors
      .add(AuthInterceptor(tokens, onSessionExpired: onSessionExpired));
  return dio;
}
