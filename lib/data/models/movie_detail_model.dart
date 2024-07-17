class MovieDetailModel {
  final int id;
  final String title;
  final String plotOverview;
  final String type;
  final int year;
  final String releaseDate;
  final String imdbId;
  final String poster;
  final double userRating;
  final List<String> sources;

  MovieDetailModel({
    required this.id,
    required this.title,
    required this.plotOverview,
    required this.type,
    required this.year,
    required this.releaseDate,
    required this.imdbId,
    required this.poster,
    required this.userRating,
    required this.sources,
  });

  factory MovieDetailModel.fromJson(Map<String, dynamic> json) {
    return MovieDetailModel(
      id: json['id'],
      title: json['title'],
      plotOverview: json['plot_overview'],
      type: json['type'],
      year: json['year'],
      releaseDate: json['release_date'],
      imdbId: json['imdb_id'],
      poster: json['poster'],
      userRating: json['user_rating'].toDouble(),
      sources:
          List<String>.from(json['sources'].map((source) => source['name'])),
    );
  }
}
