class NewsDetailDTO {
  final int newsId;
  final int categoryId;
  final String categoryType;
  final String title;
  final String paragraphs;
  final String images;
  final String actor;
  final String timeCreate;

  const NewsDetailDTO({
    required this.newsId,
    required this.categoryId,
    required this.categoryType,
    required this.title,
    required this.paragraphs,
    required this.images,
    required this.actor,
    required this.timeCreate,
  });

  factory NewsDetailDTO.fromJson(Map<String, dynamic> json) {
    return NewsDetailDTO(
      newsId: json['newsId'],
      categoryId: json['categoryId'],
      categoryType: json['categoryType'],
      title: json['title'],
      paragraphs: json['paragraphs'],
      images: json['images'],
      actor: json['actor'],
      timeCreate: json['timeCreate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsId'] = this.newsId;
    data['categoryId'] = this.categoryId;
    data['categoryType'] = this.categoryType;
    data['title'] = this.title;
    data['paragraphs'] = this.paragraphs;
    data['images'] = this.images;
    data['actor'] = this.actor;
    data['timeCreate'] = this.timeCreate;
    return data;
  }
}
