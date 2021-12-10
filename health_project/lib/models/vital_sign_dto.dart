class VitalSignDTO {
  final String id;
  final int accountId;
  final int value1;
  final int value2;
  final String time;
  final String type;

  const VitalSignDTO({
    required this.id,
    required this.accountId,
    required this.value1,
    required this.value2,
    required this.time,
    required this.type,
  });

  factory VitalSignDTO.fromJson(Map<String, dynamic> json) {
    return VitalSignDTO(
      id: json['id'],
      accountId: json['accountId'],
      value1: json['value1'],
      value2: json['value2'],
      time: json['time'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountId'] = this.accountId;
    data['value1'] = this.value1;
    data['value2'] = this.value2;
    data['time'] = this.time;
    data['type'] = this.type;
    return data;
  }
}
