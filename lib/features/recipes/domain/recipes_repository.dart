import '../../../core/data/cached_fetcher.dart';
import 'recipe.dart';

abstract class RecipesRepository {
  Future<DataResult<List<Recipe>>> getRecipes();
}
