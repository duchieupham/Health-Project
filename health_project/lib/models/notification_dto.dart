class NotificationDTO {
  final int id;
  final String description;
  final int keyId;
  final String status;
  final String timeCreated;
  final int accountId;
  final String keyType;
  final String typeName;
  final int lastMinute;

  const NotificationDTO({
    required this.id,
    required this.description,
    required this.keyId,
    required this.status,
    required this.timeCreated,
    required this.accountId,
    required this.keyType,
    required this.typeName,
    required this.lastMinute,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) {
    return NotificationDTO(
      id: json['id'],
      description: json['description'],
      keyId: json['keyId'],
      status: json['status'],
      timeCreated: json['timeCreated'],
      accountId: json['accountId'],
      keyType: json['keyType'],
      typeName: json['typeName'],
      lastMinute: json['lastMinute'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['keyId'] = this.keyId;
    data['status'] = this.status;
    data['timeCreated'] = this.timeCreated;
    data['accountId'] = this.accountId;
    data['keyType'] = this.keyType;
    data['typeName'] = this.typeName;
    data['lastMinute'] = this.lastMinute;
    return data;
  }
}
