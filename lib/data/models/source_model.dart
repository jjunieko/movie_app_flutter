class SourceModel {
  final int sourceId;
  final String name;
  final String type;
  final String region;
  final String? iosUrl;
  final String? androidUrl;
  final String? webUrl;
  final String format;
  final double? price;
  final int seasons;
  final int episodes;

  SourceModel({
    required this.sourceId,
    required this.name,
    required this.type,
    required this.region,
    this.iosUrl,
    this.androidUrl,
    this.webUrl,
    required this.format,
    this.price,
    required this.seasons,
    required this.episodes,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      sourceId: json['source_id'],
      name: json['name'],
      type: json['type'],
      region: json['region'],
      iosUrl: json['ios_url'],
      androidUrl: json['android_url'],
      webUrl: json['web_url'],
      format: json['format'],
      price: json['price'] != null ? json['price'].toDouble() : null,
      seasons: json['seasons'],
      episodes: json['episodes'],
    );
  }
}
