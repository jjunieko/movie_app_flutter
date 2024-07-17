part of 'movie_bloc.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class FetchMovies extends MovieEvent {
  final String query;

  const FetchMovies({required this.query});

  @override
  List<Object> get props => [query];
}

class FetchPopularMovies extends MovieEvent {}
