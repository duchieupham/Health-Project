class PersonalDTO {
  final int accountId;
  final String firstname;
  final String lastname;
  final int height;
  final double weight;
  final String familyHealth;
  final String healthDescription;
  final String gender;
  final String address;
  final String phone;

  const PersonalDTO({
    required this.accountId,
    required this.firstname,
    required this.lastname,
    required this.height,
    required this.weight,
    required this.familyHealth,
    required this.healthDescription,
    required this.gender,
    required this.address,
    required this.phone,
  });

  factory PersonalDTO.fromJson(Map<String, dynamic> json) {
    return PersonalDTO(
      accountId: json['accountId'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      height: json['height'],
      weight: json['weight'],
      familyHealth: json['familyHealth'],
      healthDescription: json['healthDescription'],
      gender: json['gender'],
      address: json['address'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['familyHealth'] = this.familyHealth;
    data['healthDescription'] = this.healthDescription;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['phone'] = this.phone;
    return data;
  }
}
