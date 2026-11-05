import 'package:flutter_test/flutter_test.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';
import 'package:southsea_cinema/models/movie.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
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

    test('loadMoviesFromAsset reads the JSON movie catalogue', () async {

      final MovieRepository repository = MovieRepository();

      final List<Movie> movies =
         await repository.loadMoviesFromAsset();

      expect(movies.length, 2);

      expect(movies[0].id, 'dracula-1931');
      expect(movies[0].title, 'DRACULA (1931)');
      expect(movies[0].price, 8.50);

      expect(movies[1].id, 'fast-and-furious-6');
      expect(movies[1].title, 'FAST & FURIOUS 6');
      expect(movies[1].price, 10.00);

      expect(repository.getMovies(), movies);
  });

  });
}
