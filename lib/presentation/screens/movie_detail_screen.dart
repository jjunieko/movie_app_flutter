import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final int movieId;

  MovieDetailScreen({required this.movieId});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
      ),
      body: FutureBuilder(
        future: Future.wait([
          movieProvider.fetchMovieDetails(movieId),
          movieProvider.fetchSeasons(movieId),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading movie details'));
          } else {
            final movie = movieProvider.selectedMovie!;
            final isFavorite =
                movieProvider.favorites.any((fav) => fav.id == movie.id);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    movie.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/no_image.png',
                          fit: BoxFit.cover);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text('Year: ${movie.year}'),
                        SizedBox(height: 8),
                        Text('Score: ${movie.score}'),
                        SizedBox(height: 8),
                        Text('Genres: ${movie.genres.join(', ')}'),
                        SizedBox(height: 8),
                        Text('Overview:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(movie.overview),
                        SizedBox(height: 8),
                        Text('Where to watch:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(movie.watchSources.join(', ')),
                        SizedBox(height: 8),
                        if (movie.trailerUrl.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Trailer:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              GestureDetector(
                                onTap: () {
                                  // Open the trailer URL
                                },
                                child: Image.network(
                                  movie.trailerThumbnail,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                        'assets/images/no_image.png',
                                        fit: BoxFit.cover);
                                  },
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                if (isFavorite) {
                                  movieProvider.removeFavorite(movie.id);
                                } else {
                                  movieProvider.addFavorite(movie);
                                }
                                Navigator.pop(
                                    context); // Redireciona para a tela inicial após favoritar/desfavoritar
                              },
                              icon: Icon(isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border),
                              label: Text(isFavorite
                                  ? 'Remove from Favorites'
                                  : 'Add to Favorites'),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('Seasons:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: movieProvider.seasons.length,
                          itemBuilder: (ctx, index) {
                            final season = movieProvider.seasons[index];
                            return ListTile(
                              leading: Image.network(
                                season.posterUrl,
                                fit: BoxFit.cover,
                                width: 50,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/no_image.png',
                                      fit: BoxFit.cover,
                                      width: 50);
                                },
                              ),
                              title: Text(season.name),
                              subtitle:
                                  Text('Episodes: ${season.episodeCount}'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
