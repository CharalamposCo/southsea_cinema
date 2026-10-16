import '../models/movie.dart';

class MovieRepository {
  List<Movie> getMovies() {
    return [
      const Movie(
        id: 'dracula-1931',
        title: 'DRACULA (1931)',
        description:
            'Dracula is a classic 1931 horror film about Count Dracula, '
            'a mysterious vampire who moves to England and terrorises those around him.',
        rating: 'PG',
        imagePath: 'assets/images/dracula.jpg',
        screeningTime: '18:00',
        price: 8.50,
      ),
      const Movie(
          id: 'fast-and-furious-6',
          title: 'FAST & FURIOUS 6',
          description: 'Fast & Furious 6 follows Dominic Toretto and his crew '
              'as they are offered a chance to clear their criminal records '
              'by helping take down a skilled criminal organisation.',
          rating: '12',
          imagePath: 'assets/images/fast6.jpg',
          screeningTime: '20:00',
          price: 10.00),
    ];
  }

  Movie? getMovieById(String id) {
    for (final movie in getMovies()) {
      if (movie.id == id) {
        return movie;
      }
    }

    return null;
  }
}
