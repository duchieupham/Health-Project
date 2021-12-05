class AccountPersonalDTO {
  final int id;
  final String firstname;
  final String lastname;
  final String gender;
  final String birthday;

  const AccountPersonalDTO(
      {required this.id,
      required this.firstname,
      required this.lastname,
      required this.gender,
      required this.birthday});

  factory AccountPersonalDTO.fromJson(Map<String, dynamic> json) {
    return AccountPersonalDTO(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      gender: json['gender'],
      birthday: json['birthday'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['gender'] = this.gender;
    data['birthday'] = this.birthday;
    return data;
  }
}
