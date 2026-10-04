import '../../../core/data/cached_fetcher.dart';
import '../domain/post.dart';
import '../domain/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  PostsRepositoryImpl(this._fetcher);
  final CachedFetcher _fetcher;

  @override
  Future<DataResult<List<Post>>> getPosts() => _fetcher.fetchList(
        path: '/posts',
        listKey: 'posts',
        cacheKey: 'posts',
        fromJson: Post.fromJson,
        query: {'limit': 30},
      );
}
