
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  group('Movie model tests', () {
    test('Constructor assigns properties correctly', () {
      const movie = Movie(
        id: '1',
        title: 'Dracula (1931)',
        description: 'A classic horror film',
        rating: 'PG',
        imagePath: 'assets/images/dracula.jpg',
        screeningTime: '14:00',
        price: 10.0,
      );

      expect(movie.id, '1');
      expect(movie.title, 'Dracula (1931)');
      expect(movie.description, 'A classic horror film');
      expect(movie.rating, 'PG');
      expect(movie.imagePath, 'assets/images/dracula.jpg');
      expect(movie.screeningTime, '14:00');
      expect(movie.price, 10.0);
    });

    test('formattedPrice formats whole-pound prices', () {
      const movie = Movie(
        id: '1',
        title: 'Dracula (1931)',
        description: 'A classic horror film',
        rating: 'PG',
        imagePath: 'assets/images/dracula.jpg',
        screeningTime: '14:00',
        price: 10.0,
      );

      expect(movie.formattedPrice, '£10.00');
    });

    test('formattedPrice formats prices with pence', () {
      const movie = Movie(
        id: '2',
        title: 'Fast & Furious 6',
        description: 'An action film',
        rating: '12',
        imagePath: 'assets/images/fast_and_furious_6.jpg',
        screeningTime: '19:00',
        price: 7.50,
      );

      expect(movie.formattedPrice, '£7.50');
    });
  });
}
