import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/models.dart';
import 'package:provider/provider.dart';
import '../../data/models/movie_detail_model.dart';
import '../../data/models/season_model.dart';
import '../providers/favorites_provider.dart';
import '../blocs/movie_bloc.dart';

class MovieScreen extends StatelessWidget {
  final MovieModel movie;

  const MovieScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: FutureBuilder<MovieDetailModel>(
        future: context
            .read<MovieBloc>()
            .movieRepository
            .fetchMovieDetails(movie.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to fetch movie details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final movieDetails = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(movieDetails.poster),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movieDetails.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Year: ${movieDetails.year}'),
                      const SizedBox(height: 8),
                      Text('User Rating: ${movieDetails.userRating}'),
                      const SizedBox(height: 8),
                      Text(movieDetails.plotOverview),
                      const SizedBox(height: 16),
                      const Text(
                        'Available on:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      for (var source in movieDetails.sources)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(source),
                        ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (favoritesProvider.isFavorite(movie)) {
                            favoritesProvider.removeFavorite(movie);
                          } else {
                            favoritesProvider.addFavorite(movie);
                          }
                        },
                        child: Text(
                          favoritesProvider.isFavorite(movie)
                              ? 'Remove from Favorites'
                              : 'Add to Favorites',
                        ),
                      ),
                      SizedBox(height: 16),
                      FutureBuilder<List<SeasonModel>>(
                        future: context
                            .read<MovieBloc>()
                            .movieRepository
                            .fetchSeasons(movie.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return const Center(
                                child: Text('Failed to fetch seasons'));
                          } else if (!snapshot.hasData) {
                            return const Center(
                                child: Text('No seasons available'));
                          }

                          final seasons = snapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Seasons:',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                ),
                                itemCount: seasons.length,
                                itemBuilder: (context, index) {
                                  final season = seasons[index];
                                  return Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                    top: Radius.circular(15)),
                                            child: season.posterUrl.isNotEmpty
                                                ? Image.network(
                                                    season.posterUrl,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  )
                                                : Image.asset(
                                                    'assets/no_image.png',
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                  ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                season.name,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 5),
                                              Text(
                                                'Episodes: ${season.episodeCount}',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
