import '../../../core/data/cached_fetcher.dart';
import 'post.dart';

abstract class PostsRepository {
  Future<DataResult<List<Post>>> getPosts();
}
