class AccountPasswordDTO {
  final int id;
  final String oldPassword;
  final String newPassword;

  const AccountPasswordDTO(
      {required this.id, required this.oldPassword, required this.newPassword});

  factory AccountPasswordDTO.fromJson(Map<String, dynamic> json) {
    return AccountPasswordDTO(
      id: json['id'],
      oldPassword: json['oldPassword'],
      newPassword: json['newPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['oldPassword'] = this.oldPassword;
    data['newPassword'] = this.newPassword;
    return data;
  }
}
