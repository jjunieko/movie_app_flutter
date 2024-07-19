class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String overview;
  final int year;
  final double score;
  final List<String> watchSources;
  final List<String> genres;
  final String trailerUrl;
  final String trailerThumbnail;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.overview,
    required this.year,
    required this.score,
    required this.watchSources,
    required this.genres,
    required this.trailerUrl,
    required this.trailerThumbnail,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? json['name'] ?? 'Unknown Title',
      imageUrl: json['poster'] ?? 'assets/images/no_image.png',
      overview: json['plot_overview'] ?? 'No overview available.',
      year: json['year'] ?? 0,
      score: (json['user_rating'] ?? 0).toDouble(),
      watchSources: (json['sources'] as List<dynamic>?)
              ?.map((e) => e['name'] as String)
              .toList() ??
          [],
      genres: (json['genre_names'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      trailerUrl: json['trailer'] ?? '',
      trailerThumbnail:
          json['trailer_thumbnail'] ?? 'assets/images/no_image.png',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster': imageUrl,
      'plot_overview': overview,
      'year': year,
      'user_rating': score,
      'sources': watchSources,
      'genre_names': genres,
      'trailer': trailerUrl,
      'trailer_thumbnail': trailerThumbnail,
    };
  }
}
