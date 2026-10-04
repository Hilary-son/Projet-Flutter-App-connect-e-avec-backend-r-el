import '../../../core/data/cached_fetcher.dart';
import 'product.dart';

abstract class ProductsRepository {
  Future<DataResult<List<Product>>> getProducts();
}
