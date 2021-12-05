class EventDTO {
  final String status;
  final int id;
  final String content;
  final String timeCreated;
  final String workLocation;
  final String phone;
  final String avatar;
  final String timeEvent;
  final String title;
  final int doctorId;
  final int patientId;
  final String email;
  final String latitude;
  final String dfirstname;
  final String dlastname;
  final String longtitude;

  const EventDTO({
    required this.status,
    required this.id,
    required this.content,
    required this.timeCreated,
    required this.workLocation,
    required this.phone,
    required this.avatar,
    required this.timeEvent,
    required this.title,
    required this.doctorId,
    required this.patientId,
    required this.email,
    required this.latitude,
    required this.dfirstname,
    required this.dlastname,
    required this.longtitude,
  });

  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      status: json['status'],
      id: json['id'],
      content: json['content'],
      timeCreated: json['timeCreated'],
      workLocation: json['workLocation'],
      phone: json['phone'],
      avatar: json['avatar'],
      timeEvent: json['timeEvent'],
      title: json['title'],
      doctorId: json['doctorId'],
      patientId: json['patientId'],
      email: json['email'],
      latitude: json['latitude'],
      dfirstname: json['dfirstname'],
      dlastname: json['dlastname'],
      longtitude: json['longtitude'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['id'] = this.id;
    data['content'] = this.content;
    data['timeCreated'] = this.timeCreated;
    data['workLocation'] = this.workLocation;
    data['phone'] = this.phone;
    data['avatar'] = this.avatar;
    data['timeEvent'] = this.timeEvent;
    data['title'] = this.title;
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['email'] = this.email;
    data['latitude'] = this.latitude;
    data['dfirstname'] = this.dfirstname;
    data['dlastname'] = this.dlastname;
    data['longtitude'] = this.longtitude;
    return data;
  }
}
