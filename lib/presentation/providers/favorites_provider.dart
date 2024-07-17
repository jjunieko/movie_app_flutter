import 'package:flutter/material.dart';
import 'package:myapp/data/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider with ChangeNotifier {
  List<MovieModel> _favorites = [];

  List<MovieModel> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteMoviesString = prefs.getString('favorites') ?? '[]';
    final favoriteMoviesList = json.decode(favoriteMoviesString) as List;
    _favorites = favoriteMoviesList.map((movieJson) => MovieModel.fromJson(movieJson)).toList();
    notifyListeners();
  }

  void addFavorite(MovieModel movie) async {
    _favorites.add(movie);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', json.encode(_favorites.map((movie) => movie.toJson()).toList()));
  }

  void removeFavorite(MovieModel movie) async {
    _favorites.remove(movie);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favorites', json.encode(_favorites.map((movie) => movie.toJson()).toList()));
  }

  bool isFavorite(MovieModel movie) {
    return _favorites.any((favMovie) => favMovie.title == movie.title);
  }
}
