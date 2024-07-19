import 'package:flutter/material.dart';
import 'package:myapp/presentation/screens/movie_card.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: movieProvider.favorites.isEmpty
          ? Center(child: Text('No favorites yet.'))
          : ListView.builder(
              itemCount: movieProvider.favorites.length,
              itemBuilder: (ctx, index) {
                return MovieCard(movie: movieProvider.favorites[index]);
              },
            ),
    );
  }
}
