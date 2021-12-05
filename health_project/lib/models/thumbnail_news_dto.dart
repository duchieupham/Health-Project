class ThumbnailNewsDTO {
  final int newsId;
  final int catId;
  final String image;
  final String title;
  final String actor;
  final String timeCreated;
  final int lastMinute;

  const ThumbnailNewsDTO({
    required this.newsId,
    required this.catId,
    required this.image,
    required this.title,
    required this.actor,
    required this.timeCreated,
    required this.lastMinute,
  });

  factory ThumbnailNewsDTO.fromJson(Map<String, dynamic> json) {
    return ThumbnailNewsDTO(
      newsId: json['newsId'] as int,
      catId: json['catId'] as int,
      image: json['image'] as String,
      title: json['title'] as String,
      actor: json['actor'] as String,
      timeCreated: json['timeCreated'] as String,
      lastMinute: json['lastMinute'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsId'] = this.newsId;
    data['catId'] = this.catId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['actor'] = this.actor;
    data['timeCreated'] = this.timeCreated;
    data['lastMinute'] = this.lastMinute;
    return data;
  }
}
