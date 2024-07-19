import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/models/movie.dart';
import 'package:myapp/models/season.dart';

class ApiService {
  static const String apiKey = 'KzURaVD6Vs9xgHnyzYWVfSt7aksxafIhYZaYMNJC';
  static const String baseUrl = 'https://api.watchmode.com/v1';

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/search/?apiKey=$apiKey&search_field=name&search_value=$query'));
    if (response.statusCode == 200) {
      final List<dynamic> results =
          json.decode(response.body)['title_results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<List<Movie>> fetchPopularMovies() async {
    final response =
        await http.get(Uri.parse('$baseUrl/title/popular/?apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'] ?? [];
      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<Movie> getMovieDetails(int id) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/title/$id/details/?apiKey=$apiKey&append_to_response=sources'));
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Season>> getSeasons(int id) async {
    final response =
        await http.get(Uri.parse('$baseUrl/title/$id/seasons/?apiKey=$apiKey'));
    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body);
      return results.map((season) => Season.fromJson(season)).toList();
    } else {
      throw Exception('Failed to load seasons');
    }
  }
}
