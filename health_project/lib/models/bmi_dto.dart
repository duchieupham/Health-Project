class BMIDTO {
  final String gender;
  final double height;
  final double weight;
  final int id;

  const BMIDTO({
    required this.gender,
    required this.height,
    required this.weight,
    required this.id,
  });

  factory BMIDTO.fromJson(Map<String, dynamic> json) {
    return BMIDTO(
      gender: json['gender'],
      height: json['height'],
      weight: json['weight'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['id'] = this.id;
    return data;
  }
}
