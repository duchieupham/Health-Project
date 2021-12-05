class AccountContactDTO {
  final int id;
  final String address;
  final String phone;

  const AccountContactDTO(
      {required this.id, required this.address, required this.phone});

  factory AccountContactDTO.fromJson(Map<String, dynamic> json) {
    return AccountContactDTO(
      id: json['id'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
