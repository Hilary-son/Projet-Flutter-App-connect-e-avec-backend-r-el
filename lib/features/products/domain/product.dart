class Product {
  final int id;
  final String title, description, thumbnail, category;
  final double price, rating;
  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.category,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'] as int,
        title: j['title'] as String? ?? '',
        description: j['description'] as String? ?? '',
        thumbnail: j['thumbnail'] as String? ?? '',
        category: j['category'] as String? ?? '',
        price: (j['price'] as num?)?.toDouble() ?? 0,
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
      );
}
