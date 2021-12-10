import 'package:equatable/equatable.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/models/bmi_dto.dart';
import 'package:health_project/models/vital_sign_dto.dart';

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

//event for get list and show it in chart by chart type
class HeartRateGetListEvent extends HealthEvent {
  final VitalSignDTO dto;
  final ChartType chartType;

  const HeartRateGetListEvent({
    required this.dto,
    required this.chartType,
  });

  @override
  List<Object> get props => [dto, chartType];
}

//event for measure heart rate
class HeartRateMeasureEvent extends HealthEvent {
  final String peripheralId;

  const HeartRateMeasureEvent({required this.peripheralId});

  @override
  List<Object> get props => [peripheralId];
}

//event for add (insert/update) value into sqflite
class HeartRateAddValueEvent extends HealthEvent {
  final VitalSignDTO dto;
  final ChartType chartType;

  const HeartRateAddValueEvent({
    required this.dto,
    required this.chartType,
  });

  @override
  List<Object> get props => [dto, chartType];
}

//event for listen response heart rate
class HeartRateResponseEvent extends HealthEvent {
  final int value;

  const HeartRateResponseEvent({required this.value});

  @override
  List<Object> get props => [value];
}
