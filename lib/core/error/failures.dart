import 'package:dio/dio.dart';

class Failure implements Exception {
  final String message;
  const Failure(this.message);
  @override
  String toString() => message;
}

Failure mapDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.sendTimeout:
      return const Failure('Le serveur met trop de temps à répondre.');
    case DioExceptionType.connectionError:
      return const Failure('Pas de connexion Internet.');
    case DioExceptionType.badResponse:
      final code = e.response?.statusCode;
      if (code == 400) return const Failure('Identifiants incorrects.');
      if (code == 401) return const Failure('Session expirée, reconnecte-toi.');
      if (code == 404) return const Failure('Ressource introuvable.');
      return Failure('Erreur serveur ($code).');
    default:
      return const Failure('Une erreur inattendue est survenue.');
  }
}
