class Recipe {
  final int id, prepTimeMinutes;
  final String name, image, cuisine, difficulty;
  final double rating;
  const Recipe({
    required this.id,
    required this.name,
    required this.image,
    required this.cuisine,
    required this.difficulty,
    required this.prepTimeMinutes,
    required this.rating,
  });

  factory Recipe.fromJson(Map<String, dynamic> j) => Recipe(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
        image: j['image'] as String? ?? '',
        cuisine: j['cuisine'] as String? ?? '',
        difficulty: j['difficulty'] as String? ?? '',
        prepTimeMinutes: (j['prepTimeMinutes'] as num?)?.toInt() ?? 0,
        rating: (j['rating'] as num?)?.toDouble() ?? 0,
      );
}
