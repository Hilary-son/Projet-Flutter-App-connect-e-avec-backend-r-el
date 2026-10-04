import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_recipes/core/error/failures.dart';
import 'package:shop_recipes/core/storage/cache_service.dart';
import 'package:shop_recipes/core/storage/token_storage.dart';
import 'package:shop_recipes/features/auth/data/auth_repository_impl.dart';

class MockDio extends Mock implements Dio {}

class MockTokens extends Mock implements TokenStorage {}

class MockCache extends Mock implements CacheService {}

void main() {
  late MockDio dio;
  late MockTokens tokens;
  late MockCache cache;
  late AuthRepositoryImpl repo;

  setUpAll(() => registerFallbackValue(<String, dynamic>{}));

  setUp(() {
    dio = MockDio();
    tokens = MockTokens();
    cache = MockCache();
    repo = AuthRepositoryImpl(dio, tokens, cache);
    when(() => tokens.save(
        access: any(named: 'access'),
        refresh: any(named: 'refresh'))).thenAnswer((_) async {});
    when(() => cache.saveMap(any(), any())).thenAnswer((_) async {});
  });

  test('login réussi : sauvegarde les tokens et retourne l\'utilisateur',
      () async {
    when(() => dio.post<dynamic>(any(), data: any(named: 'data')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/auth/login'),
              statusCode: 200,
              data: {
                'id': 1,
                'username': 'emilys',
                'email': 'e@x.com',
                'firstName': 'Emily',
                'lastName': 'J',
                'image': '',
                'accessToken': 'A',
                'refreshToken': 'R',
              },
            ));

    final user = await repo.login('emilys', 'emilyspass');

    expect(user.username, 'emilys');
    verify(() => tokens.save(access: 'A', refresh: 'R')).called(1);
  });

  test('login échoué (400) : lève une Failure "Identifiants incorrects"',
      () async {
    final req = RequestOptions(path: '/auth/login');
    when(() => dio.post<dynamic>(any(), data: any(named: 'data')))
        .thenThrow(DioException(
      requestOptions: req,
      type: DioExceptionType.badResponse,
      response: Response(requestOptions: req, statusCode: 400),
    ));

    expect(
      () => repo.login('x', 'y'),
      throwsA(isA<Failure>()
          .having((f) => f.message, 'message', 'Identifiants incorrects.')),
    );
    verifyNever(() => tokens.save(
        access: any(named: 'access'), refresh: any(named: 'refresh')));
  });
}
