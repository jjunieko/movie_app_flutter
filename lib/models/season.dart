class Season {
  final int id;
  final String posterUrl;
  final String name;
  final String overview;
  final int number;
  final String airDate;
  final int episodeCount;

  Season({
    required this.id,
    required this.posterUrl,
    required this.name,
    required this.overview,
    required this.number,
    required this.airDate,
    required this.episodeCount,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'],
      posterUrl: json['poster_url'] ?? 'assets/images/no_image.png',
      name: json['name'] ?? 'Unknown Season',
      overview: json['overview'] ?? 'No overview available.',
      number: json['number'] ?? 0,
      airDate: json['air_date'] ?? 'Unknown date',
      episodeCount: json['episode_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poster_url': posterUrl,
      'name': name,
      'overview': overview,
      'number': number,
      'air_date': airDate,
      'episode_count': episodeCount,
    };
  }
}
