import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoritesProvider.favorites.length,
        itemBuilder: (context, index) {
          final movie = favoritesProvider.favorites[index];
          return ListTile(
            title: Text(movie.title),
            subtitle: Text(movie.year),
            leading: Image.network(movie.imageUrl),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/movie',
                arguments: movie,
              );
            },
          );
        },
      ),
    );
  }
}
