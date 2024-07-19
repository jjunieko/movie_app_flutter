// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/presentation/screens/movie_card.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.of(context).pushNamed('/favorites');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search movies...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                movieProvider.searchMovies(query);
              },
            ),
          ),
          Expanded(
            child: movieProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: movieProvider.movies.isNotEmpty
                        ? movieProvider.movies.length
                        : movieProvider.popularMovies.length,
                    itemBuilder: (ctx, index) {
                      final movie = movieProvider.movies.isNotEmpty
                          ? movieProvider.movies[index]
                          : movieProvider.popularMovies[index];
                      return MovieCard(movie: movie);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
