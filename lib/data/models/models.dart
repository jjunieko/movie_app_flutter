class MovieModel {
  final int id;
  final String title;
  final String imageUrl;
  final String synopsis;
  final String year;
  final double score;

  MovieModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.synopsis,
    required this.year,
    required this.score,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['name'],
      imageUrl: json['poster'] ?? '',
      synopsis: json['plot_overview'] ?? '',
      year: json['year'].toString(),
      score: json['user_rating']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'poster': imageUrl,
      'plot_overview': synopsis,
      'year': year,
      'user_rating': score,
    };
  }
}
