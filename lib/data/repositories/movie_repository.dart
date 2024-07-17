import 'package:http/http.dart' as http;
import 'package:myapp/data/models/models.dart';
import 'package:myapp/data/models/movie_detail_model.dart';
import 'dart:convert';
import '../../core/config.dart'; // Importe o arquivo de configuração

import '../models/season_model.dart';
import '../models/source_model.dart';

class MovieRepository {
  final http.Client client;

  MovieRepository({required this.client});

  Future<List<MovieModel>> fetchMovies(String query) async {
    final response = await client.get(
      Uri.parse(
          'https://api.watchmode.com/v1/search/?apiKey=$apiKey&search_field=name&search_value=$query'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson =
          json.decode(response.body)['title_results'];
      return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<List<MovieModel>> fetchPopularMovies() async {
    final response = await client.get(
      Uri.parse(
          'https://api.watchmode.com/v1/list-titles/?apiKey=$apiKey&types=movie&sort_by=popularity_desc'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> moviesJson = json.decode(response.body)['titles'];
      return moviesJson.map((json) => MovieModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch popular movies');
    }
  }

  Future<MovieDetailModel> fetchMovieDetails(int id) async {
    final response = await client.get(
      Uri.parse(
          'https://api.watchmode.com/v1/title/$id/details/?apiKey=$apiKey&append_to_response=sources'),
    );

    if (response.statusCode == 200) {
      final movieJson = json.decode(response.body);
      return MovieDetailModel.fromJson(movieJson);
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<List<SeasonModel>> fetchSeasons(int id) async {
    final response = await client.get(
      Uri.parse(
          'https://api.watchmode.com/v1/title/345534/seasons/?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> seasonsJson = json.decode(response.body);
      return seasonsJson.map((json) => SeasonModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch seasons');
    }
  }

  Future<List<SourceModel>> fetchSources(int id) async {
    final response = await client.get(
      Uri.parse(
          'https://api.watchmode.com/v1/title/345534/sources/?apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> sourcesJson = json.decode(response.body);
      return sourcesJson.map((json) => SourceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch sources');
    }
  }
}
