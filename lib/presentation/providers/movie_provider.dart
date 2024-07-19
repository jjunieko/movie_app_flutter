// lib/providers/movie_provider.dart
import 'package:flutter/material.dart';
import 'package:myapp/data/repositories/movie_repository.dart';
import 'package:myapp/models/movie.dart';
import 'package:myapp/models/season.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  List<Movie> _popularMovies = [];
  List<Season> _seasons = [];
  Movie? _selectedMovie;
  bool _isLoading = false;
  List<Movie> _favorites = [];

  List<Movie> get movies => _movies;
  List<Movie> get popularMovies => _popularMovies;
  List<Season> get seasons => _seasons;
  Movie? get selectedMovie => _selectedMovie;
  bool get isLoading => _isLoading;
  List<Movie> get favorites => _favorites;

  final ApiService apiService = ApiService();

  MovieProvider() {
    loadFavorites();
    fetchPopularMovies();
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    notifyListeners();
    _movies = await apiService.searchMovies(query);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPopularMovies() async {
    _isLoading = true;
    notifyListeners();
    _popularMovies = await apiService.fetchPopularMovies();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchMovieDetails(int id) async {
    _isLoading = true;
    notifyListeners();
    _selectedMovie = await apiService.getMovieDetails(id);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSeasons(int id) async {
    _isLoading = true;
    notifyListeners();
    _seasons = await apiService.getSeasons(id);
    _isLoading = false;
    notifyListeners();
  }

  void addFavorite(Movie movie) {
    _favorites.add(movie);
    saveFavorites();
    notifyListeners();
  }

  void removeFavorite(int id) {
    _favorites.removeWhere((movie) => movie.id == id);
    saveFavorites();
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteMovies =
        _favorites.map((movie) => json.encode(movie.toJson())).toList();
    await prefs.setStringList('favorites', favoriteMovies);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? favoriteMovies = prefs.getStringList('favorites');
    if (favoriteMovies != null) {
      _favorites = favoriteMovies
          .map((movie) => Movie.fromJson(json.decode(movie)))
          .toList();
    }
    notifyListeners();
  }
}
