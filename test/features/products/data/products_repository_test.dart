import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shop_recipes/core/data/cached_fetcher.dart';
import 'package:shop_recipes/core/error/failures.dart';
import 'package:shop_recipes/core/network/network_info.dart';
import 'package:shop_recipes/core/storage/cache_service.dart';
import 'package:shop_recipes/features/products/data/products_repository_impl.dart';

class MockDio extends Mock implements Dio {}

class MockCache extends Mock implements CacheService {}

class MockNetwork extends Mock implements NetworkInfo {}

void main() {
  late MockDio dio;
  late MockCache cache;
  late MockNetwork network;
  late ProductsRepositoryImpl repo;

  final productJson = {
    'id': 1,
    'title': 'Phone',
    'description': 'desc',
    'thumbnail': 'url',
    'category': 'tech',
    'price': 99.9,
    'rating': 4.5,
  };

  setUpAll(() => registerFallbackValue(<Map<String, dynamic>>[]));

  setUp(() {
    dio = MockDio();
    cache = MockCache();
    network = MockNetwork();
    repo = ProductsRepositoryImpl(CachedFetcher(dio, cache, network));
    when(() => cache.saveList(any(), any())).thenAnswer((_) async {});
  });

  test('en ligne : appelle l\'API, met en cache et retourne les données',
      () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => dio.get<dynamic>(any(),
            queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: '/products'),
              statusCode: 200,
              data: {
                'products': [productJson]
              },
            ));

    final result = await repo.getProducts();

    expect(result.fromCache, false);
    expect(result.data.first.title, 'Phone');
    verify(() => cache.saveList('products', any())).called(1);
  });

  test('hors-ligne avec cache : retourne le cache sans appeler l\'API',
      () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    when(() => cache.readList('products')).thenReturn([productJson]);

    final result = await repo.getProducts();

    expect(result.fromCache, true);
    expect(result.data.length, 1);
    verifyNever(() => dio.get<dynamic>(any(),
        queryParameters: any(named: 'queryParameters')));
  });

  test('hors-ligne sans cache : lève une Failure claire', () async {
    when(() => network.isConnected).thenAnswer((_) async => false);
    when(() => cache.readList('products')).thenReturn(null);

    expect(() => repo.getProducts(), throwsA(isA<Failure>()));
  });

  test('en ligne mais l\'API échoue : bascule sur le cache', () async {
    when(() => network.isConnected).thenAnswer((_) async => true);
    when(() => dio.get<dynamic>(any(),
            queryParameters: any(named: 'queryParameters')))
        .thenThrow(DioException(
      requestOptions: RequestOptions(path: '/products'),
      type: DioExceptionType.connectionError,
    ));
    when(() => cache.readList('products')).thenReturn([productJson]);

    final result = await repo.getProducts();

    expect(result.fromCache, true);
  });
}
