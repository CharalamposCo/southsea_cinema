import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/movie.dart';
import '../repositories/movie_repository.dart';
import '../widgets/movie_card.dart';
import '../widgets/nav_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Movie> _movies = [];
  bool _loading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    
    try {
      final MovieRepository repository = MovieRepository();

      final List<Movie> movies =
          await repository.loadMoviesFromAsset();

      if (!mounted) {
        return;
      }

      setState(() {
        _movies = movies;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = 'Could not load the movies: $error';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget body;

    if (_loading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_errorMessage.isNotEmpty) {
      body = Center(
        child: Text(_errorMessage),
      );
    } else {
      body = ListView.builder(
        itemCount: _movies.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Welcome to Southsea Cinema'),
            );
          }

    return MovieCard(movie: _movies[index - 1]);
  },
);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: cinemaHeaderStyle,
        ),
        backgroundColor: cinemaSurface,
      ),
      drawer: const NavDrawer(),
      body: body,
    );
  }
}