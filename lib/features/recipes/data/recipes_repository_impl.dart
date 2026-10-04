import '../../../core/data/cached_fetcher.dart';
import '../domain/recipe.dart';
import '../domain/recipes_repository.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  RecipesRepositoryImpl(this._fetcher);
  final CachedFetcher _fetcher;

  @override
  Future<DataResult<List<Recipe>>> getRecipes() => _fetcher.fetchList(
        path: '/recipes',
        listKey: 'recipes',
        cacheKey: 'recipes',
        fromJson: Recipe.fromJson,
        query: {'limit': 30},
      );
}
