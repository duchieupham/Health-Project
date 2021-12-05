class AccountTokenDTO {
  final int accountId;
  final String firstName;
  final String lastName;
  final String avatar;
  final List<String> authorities;
  final int iat;
  final int exp;

  const AccountTokenDTO({
    required this.accountId,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.authorities,
    required this.iat,
    required this.exp,
  });

  factory AccountTokenDTO.fromJson(Map<String, dynamic> json) {
    return AccountTokenDTO(
      accountId: json['accountId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      avatar: json['avatar'],
      authorities: json['authorities'].cast<String>(),
      iat: json['iat'],
      exp: json['exp'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accountId'] = this.accountId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['avatar'] = this.avatar;
    data['authorities'] = this.authorities;
    data['iat'] = this.iat;
    data['exp'] = this.exp;
    return data;
  }
}
