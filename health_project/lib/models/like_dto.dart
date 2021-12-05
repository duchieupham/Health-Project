class LikeDTO {
  final String name;
  final String avatar;
  final int newsId;
  final int accountId;

  const LikeDTO({
    required this.name,
    required this.avatar,
    required this.newsId,
    required this.accountId,
  });

  factory LikeDTO.fromJson(Map<String, dynamic> json) {
    return LikeDTO(
      name: json['name'],
      avatar: json['avatar'],
      newsId: json['newsId'],
      accountId: json['accountId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['newsId'] = this.newsId;
    data['accountId'] = this.accountId;
    return data;
  }
}
