class CategoryNewsDTO {
  final int id;
  final String typeName;
  final String image;
  final String description;

  const CategoryNewsDTO({
    required this.id,
    required this.typeName,
    required this.image,
    required this.description,
  });

  factory CategoryNewsDTO.fromJson(Map<String, dynamic> json) {
    return CategoryNewsDTO(
      id: json['id'],
      typeName: json['typeName'],
      image: json['image'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['typeName'] = this.typeName;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}
