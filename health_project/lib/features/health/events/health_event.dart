import 'package:equatable/equatable.dart';
import 'package:health_project/models/bmi_dto.dart';

abstract class HealthEvent extends Equatable {
  const HealthEvent();
}

class ActivityEventGet extends HealthEvent {
  final String peripheralId;
  final int accountId;

  const ActivityEventGet({
    required this.peripheralId,
    required this.accountId,
  });

  @override
  List<Object> get props => [peripheralId, accountId];
}

class ActivityEventGetList extends HealthEvent {
  final int accountId;

  const ActivityEventGetList({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class BMIEventGet extends HealthEvent {
  final int accountId;

  const BMIEventGet({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class BMIEventUpdate extends HealthEvent {
  final BMIDTO dto;

  const BMIEventUpdate({required this.dto});

  @override
  List<Object> get props => [dto];
}
