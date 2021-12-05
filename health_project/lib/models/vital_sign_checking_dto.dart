import 'package:health_project/commons/constants/enum.dart';

class VitalSignCheckingDTO {
  final VitalSignType type;
  final bool isContained;

  const VitalSignCheckingDTO({required this.type, required this.isContained});

  factory VitalSignCheckingDTO.fromJson(Map<String, dynamic> json) {
    return VitalSignCheckingDTO(
      type: json['type'],
      isContained: json['isContained'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['isContained'] = this.isContained;
    return data;
  }
}
