import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/data/models/season_model.dart';
import '../blocs/movie_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search for movies',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) {
                context.read<MovieBloc>().add(FetchMovies(query: query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, state) {
                if (state is MovieInitial) {
                  context.read<MovieBloc>().add(FetchPopularMovies());
                  return const Center(child: Text('Loading popular movies...'));
                } else if (state is MovieLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MovieLoaded) {
                  return ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (context, index) {
                      final movie = state.movies[index];
                      return ListTile(
                        title: Text(movie.title),
                        subtitle: Text(movie.year),
                        leading: movie.imageUrl.isNotEmpty
                            ? Image.network(
                                movie.imageUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/no_image.png',
                                    fit: BoxFit.cover,
                                    width: 50,
                                  );
                                },
                              )
                            : Image.asset(
                                'assets/no_image.png',
                                fit: BoxFit.cover,
                                width: 50,
                              ),
                        onTap: () async {
                          final movieRepository = context.read<MovieBloc>().movieRepository;
                          final seasons = await movieRepository.fetchSeasons(movie.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeasonsScreen(seasons: seasons),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is MovieError) {
                  return const Center(child: Text('Failed to fetch movies'));
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SeasonsScreen extends StatelessWidget {
  final List<SeasonModel> seasons;

  const SeasonsScreen({Key? key, required this.seasons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seasons'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15)),
                    child: season.posterUrl.isNotEmpty
                        ? Image.network(
                            season.posterUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/no_image.png',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              );
                            },
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
    );
  }
}
