import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/movie_card.dart';
import 'package:southsea_cinema/repositories/movie_repository.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final movies = MovieRepository().getMovies();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
        backgroundColor: cinemaSurface,
        iconTheme: const IconThemeData(color: cinemaBrand),
        elevation: 0,
      ),
      drawer: const NavDrawer(),
     
body: ListView(
  padding: const EdgeInsets.all(16),
  children: [
    const Text(
      'Welcome to Southsea Cinema',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: cinemaFontWhite,
      ),
    ),

    
    const SizedBox(height: 20),

   
    ...movies.map(
      (movie) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: MovieCard(movie: movie),
      ),
    ),
  ],
),

    );
  }
}
