import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:myapp/data/models/models.dart';

import '../../data/repositories/movie_repository.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  MovieBloc({required this.movieRepository}) : super(MovieInitial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchPopularMovies>(_onFetchPopularMovies);
  }

  void _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.fetchMovies(event.query);
      emit(MovieLoaded(movies: movies));
    } catch (_) {
      emit(MovieError());
    }
  }

  void _onFetchPopularMovies(
      FetchPopularMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      final movies = await movieRepository.fetchPopularMovies();
      emit(MovieLoaded(movies: movies));
    } catch (_) {
      emit(MovieError());
    }
  }
}
