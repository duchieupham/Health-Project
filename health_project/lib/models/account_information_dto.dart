class AccountInformationDTO {
  final String username;
  final String phone;
  final String firstname;
  final String lastname;
  final String gender;
  final String birthday;
  final String address;

  const AccountInformationDTO(
      {required this.username,
      required this.phone,
      required this.firstname,
      required this.lastname,
      required this.gender,
      required this.birthday,
      required this.address});

  factory AccountInformationDTO.fromJson(Map<String, dynamic> json) {
    return AccountInformationDTO(
      username: json['username'],
      phone: json['phone'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      gender: json['gender'],
      birthday: json['birthday'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone'] = this.phone;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    data['address'] = this.address;
    return data;
  }
}
