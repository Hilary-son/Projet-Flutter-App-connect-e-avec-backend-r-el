import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/cached_fetcher.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/async_list_view.dart';
import '../data/products_repository_impl.dart';
import '../domain/product.dart';
import '../domain/products_repository.dart';

final productsRepositoryProvider = Provider<ProductsRepository>(
    (ref) => ProductsRepositoryImpl(ref.watch(cachedFetcherProvider)));

final productsProvider = FutureProvider<DataResult<List<Product>>>(
    (ref) => ref.watch(productsRepositoryProvider).getProducts());

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncListView<Product>(
        value: ref.watch(productsProvider),
        onRefresh: () async {
          await ref.refresh(productsProvider.future);
        },
        itemBuilder: (_, p) => ListTile(
          leading: networkImage(p.thumbnail),
          title: Text(p.title),
          subtitle: Text('${p.category} • ★ ${p.rating}'),
          trailing: Text('${p.price.toStringAsFixed(2)} \$'),
        ),
      );
}
