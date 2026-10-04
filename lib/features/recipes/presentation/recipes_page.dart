import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/cached_fetcher.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/async_list_view.dart';
import '../data/recipes_repository_impl.dart';
import '../domain/recipe.dart';
import '../domain/recipes_repository.dart';

final recipesRepositoryProvider = Provider<RecipesRepository>(
    (ref) => RecipesRepositoryImpl(ref.watch(cachedFetcherProvider)));

final recipesProvider = FutureProvider<DataResult<List<Recipe>>>(
    (ref) => ref.watch(recipesRepositoryProvider).getRecipes());

class RecipesPage extends ConsumerWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncListView<Recipe>(
        value: ref.watch(recipesProvider),
        onRefresh: () async {
          await ref.refresh(recipesProvider.future);
        },
        itemBuilder: (_, r) => ListTile(
          leading: networkImage(r.image),
          title: Text(r.name),
          subtitle: Text(
              '${r.cuisine} • ${r.difficulty} • ${r.prepTimeMinutes} min • ★ ${r.rating}'),
        ),
      );
}
