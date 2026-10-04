import '../../../core/data/cached_fetcher.dart';
import '../domain/product.dart';
import '../domain/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._fetcher);
  final CachedFetcher _fetcher;

  @override
  Future<DataResult<List<Product>>> getProducts() => _fetcher.fetchList(
        path: '/products',
        listKey: 'products',
        cacheKey: 'products',
        fromJson: Product.fromJson,
        query: {'limit': 30},
      );
}
