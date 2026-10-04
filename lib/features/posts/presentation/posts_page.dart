import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/data/cached_fetcher.dart';
import '../../../core/providers.dart';
import '../../../core/widgets/async_list_view.dart';
import '../data/posts_repository_impl.dart';
import '../domain/post.dart';
import '../domain/posts_repository.dart';

final postsRepositoryProvider = Provider<PostsRepository>(
    (ref) => PostsRepositoryImpl(ref.watch(cachedFetcherProvider)));

final postsProvider = FutureProvider<DataResult<List<Post>>>(
    (ref) => ref.watch(postsRepositoryProvider).getPosts());

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncListView<Post>(
        value: ref.watch(postsProvider),
        onRefresh: () async {
          await ref.refresh(postsProvider.future);
        },
        itemBuilder: (_, p) => ListTile(
          title: Text(p.title),
          subtitle: Text(p.body, maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: Text(p.tags.take(2).join(', ')),
        ),
      );
}
