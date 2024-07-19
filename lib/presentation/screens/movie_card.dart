import 'package:flutter/material.dart';
import 'package:myapp/models/movie.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  MovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.network(
          movie.imageUrl,
          fit: BoxFit.cover,
          width: 50,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/images/no_image.png',
                fit: BoxFit.cover, width: 50);
          },
        ),
        title: Text(movie.title),
        subtitle: Text(movie.year.toString()),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen(movieId: movie.id),
            ),
          );
        },
      ),
    );
  }
}
