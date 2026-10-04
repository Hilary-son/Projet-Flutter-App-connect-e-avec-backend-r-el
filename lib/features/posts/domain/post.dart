class Post {
  final int id;
  final String title, body;
  final List<String> tags;
  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> j) => Post(
        id: j['id'] as int,
        title: j['title'] as String? ?? '',
        body: j['body'] as String? ?? '',
        tags: (j['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
      );
}
