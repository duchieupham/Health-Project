class ActivityDTO {
  final String id;
  final int accountId;
  final int step;
  final int meter;
  final int calorie;
  final String dateTime;

  const ActivityDTO({
    required this.id,
    required this.accountId,
    required this.step,
    required this.meter,
    required this.calorie,
    required this.dateTime,
  });

  factory ActivityDTO.fromJson(Map<String, dynamic> json) {
    return ActivityDTO(
      id: json['id'],
      accountId: json['accountId'],
      step: json['step'],
      meter: json['meter'],
      calorie: json['calorie'],
      dateTime: json['dateTime'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['accountId'] = this.accountId;
    data['step'] = this.step;
    data['meter'] = this.meter;
    data['calorie'] = this.calorie;
    data['dateTime'] = this.dateTime;
    return data;
  }
}
