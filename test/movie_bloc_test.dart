import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:myapp/data/models/models.dart';
import 'package:myapp/data/repositories/movie_repository.dart';
import 'package:myapp/presentation/blocs/movie_bloc.dart';

class MockMovieRepository extends Mock implements MovieRepository {}

void main() {
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
  });

  group('MovieBloc', () {
    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieLoaded] when FetchMovies is added and fetchMovies is successful',
      build: () {
        when(mockMovieRepository.fetchMovies('Inception')).thenAnswer(
          (_) async => [
            MovieModel(
              id: 1,
              title: 'Inception',
              imageUrl: 'https://example.com/inception.jpg',
              synopsis: 'A mind-bending thriller',
              year: '2010',
              score: 8.8,
            ),
          ],
        );
        return MovieBloc(movieRepository: mockMovieRepository);
      },
      act: (bloc) => bloc.add(FetchMovies(query: 'Inception')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieLoading(),
        MovieLoaded(
          movies: [
            MovieModel(
              id: 1,
              title: 'Inception',
              imageUrl: 'https://example.com/inception.jpg',
              synopsis: 'A mind-bending thriller',
              year: '2010',
              score: 8.8,
            ),
          ],
        ),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when FetchMovies is added and fetchMovies fails',
      build: () {
        when(mockMovieRepository.fetchMovies('Inception'))
            .thenThrow(Exception('Failed to fetch movies'));
        return MovieBloc(movieRepository: mockMovieRepository);
      },
      act: (bloc) => bloc.add(FetchMovies(query: 'Inception')),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieLoading(),
        MovieError(),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieLoaded] when FetchPopularMovies is added and fetchPopularMovies is successful',
      build: () {
        when(mockMovieRepository.fetchPopularMovies()).thenAnswer(
          (_) async => [
            MovieModel(
              id: 1,
              title: 'Inception',
              imageUrl: 'https://example.com/inception.jpg',
              synopsis: 'A mind-bending thriller',
              year: '2010',
              score: 8.8,
            ),
          ],
        );
        return MovieBloc(movieRepository: mockMovieRepository);
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieLoading(),
        MovieLoaded(
          movies: [
            MovieModel(
              id: 1,
              title: 'Inception',
              imageUrl: 'https://example.com/inception.jpg',
              synopsis: 'A mind-bending thriller',
              year: '2010',
              score: 8.8,
            ),
          ],
        ),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieError] when FetchPopularMovies is added and fetchPopularMovies fails',
      build: () {
        when(mockMovieRepository.fetchPopularMovies())
            .thenThrow(Exception('Failed to fetch movies'));
        return MovieBloc(movieRepository: mockMovieRepository);
      },
      act: (bloc) => bloc.add(FetchPopularMovies()),
      wait: const Duration(milliseconds: 500),
      expect: () => [
        MovieLoading(),
        MovieError(),
      ],
    );
  });
}
