class Movie {
  final String id;
  final String title;
  final String description;
  final String rating;
  final String imagePath;
  final String screeningTime;
  final double price;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.rating,
    required this.imagePath,
    required this.screeningTime,
    required this.price,
  });
  String get formattedPrice => '£${price.toStringAsFixed(2)}';
}