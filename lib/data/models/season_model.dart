class SeasonModel {
  final int id;
  final String posterUrl;
  final String name;
  final String overview;
  final int number;
  final String airDate;
  final int episodeCount;

  SeasonModel({
    required this.id,
    required this.posterUrl,
    required this.name,
    required this.overview,
    required this.number,
    required this.airDate,
    required this.episodeCount,
  });

  factory SeasonModel.fromJson(Map<String, dynamic> json) {
    return SeasonModel(
      id: json['id'],
      posterUrl: json['poster_url'] ?? '',
      name: json['name'],
      overview: json['overview'] ?? '',
      number: json['number'],
      airDate: json['air_date'] ?? '',
      episodeCount: json['episode_count'],
    );
  }
}
