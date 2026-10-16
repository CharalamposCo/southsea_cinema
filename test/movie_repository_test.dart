
import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

void main() {
  group('MovieRepository tests', () {
    final repository = MovieRepository();

    test('Returns the expected mock films', () {
      final movies = repository.getMovies();

      expect(movies.length, 2);
      expect(movies[0].id, 'dracula-1931');
      expect(movies[1].id, 'fast-and-furious-6');
    });

    test('Returns a movie when the ID exists', () {
      final movie = repository.getMovieById('dracula-1931');

      expect(movie, isNotNull);
      expect(movie!.id, 'dracula-1931');
      expect(movie.title, 'DRACULA (1931)');
    });

    test('Returns null when the ID does not exist', () {
      final movie = repository.getMovieById('unknown-id');

      expect(movie, isNull);
    });
  });
}
