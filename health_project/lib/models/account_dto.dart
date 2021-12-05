class AccountDTO {
  final String username;
  final String password;
  final String phone;
  final bool isLoginPhone;

  const AccountDTO({
    required this.username,
    required this.password,
    required this.phone,
    required this.isLoginPhone,
  });

  factory AccountDTO.fromJson(Map<String, dynamic> json) {
    return AccountDTO(
      username: json['username'],
      password: json['password'],
      phone: json['phone'],
      isLoginPhone: json['isLoginPhone'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    data['phone'] = this.phone;
    data['isLoginPhone'] = this.isLoginPhone;
    return data;
  }
}
