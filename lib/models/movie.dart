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

  factory Movie.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String title = json['title'] as String;
    final String description = json['description'] as String;
    final String rating = json['rating'] as String;
    final String imagePath = json['imagePath'] as String;
    final String screeningTime = json['screeningTime'] as String;
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();

    return Movie(
      id: id,
      title: title,
      description: description,
      rating: rating,
      imagePath: imagePath,
      screeningTime: screeningTime,
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'rating': rating,
      'imagePath': imagePath,
      'screeningTime': screeningTime,
      'price': price,
    };

    return data;
  }
}
