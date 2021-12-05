class LikeActionDTO {
  final int newsId;
  final int accountId;

  const LikeActionDTO({
    required this.newsId,
    required this.accountId,
  });

  factory LikeActionDTO.fromJson(Map<String, dynamic> json) {
    return LikeActionDTO(
      newsId: json['newsId'],
      accountId: json['accountId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['newsId'] = this.newsId;
    data['accountId'] = this.accountId;
    return data;
  }
}
