import 'package:equatable/equatable.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/models/activitiy_dto.dart';
import 'package:health_project/models/bmi_dto.dart';
import 'package:health_project/models/vital_sign_dto.dart';

abstract class HealthState extends Equatable {
  const HealthState();

  @override
  List<Object> get props => [];
}

//states for get activity from peripheral
class ActivityPInitialState extends HealthState {}

class ActivityPFailedState extends HealthState {}

class ActivityPGetListFailedState extends HealthState {}

class ActivityPLoadingState extends HealthState {}

class ActivityPGetListSuccessState extends HealthState {
  final List<ActivityDTO> list;

  const ActivityPGetListSuccessState({required this.list});

  @override
  List<Object> get props => [list];
}

class ActivityPSuccessState extends HealthState {
  final ActivityDTO dto;

  const ActivityPSuccessState({required this.dto});

  @override
  List<Object> get props => [dto];
}

//states for get and update bmi
class BMIInitialState extends HealthState {}

class BMILoadingState extends HealthState {}

class BMIUpdateSuccessState extends HealthState {}

class BMILoadSuccessState extends HealthState {
  final BMIDTO dto;

  const BMILoadSuccessState({required this.dto});

  @override
  List<Object> get props => [dto];
}

class BMILoadFailedState extends HealthState {}

class BMIUpdateFailedState extends HealthState {
  final BMIUpdateMsgType type;

  const BMIUpdateFailedState({required this.type});

  @override
  List<Object> get props => [type];
}

//HEART RATE STATES
//heart rate events
class HeartRateInitialState extends HealthState {}

//loading heart rate list
class HeartRateLoadingListState extends HealthState {}

//measuring heart rate
class HeartRateMeasuringState extends HealthState {}

//value response state
class HeartRateValueResponseState extends HealthState {
  final int value;
  const HeartRateValueResponseState({required this.value});

  @override
  List<Object> get props => [value];
}

//success getting heart rate list
class HeartRateSuccessfulListState extends HealthState {
  final List<VitalSignDTO> list;
  final VitalSignDTO lastValue;

  const HeartRateSuccessfulListState(
      {required this.list, required this.lastValue});

  @override
  List<Object> get props => [list, lastValue];
}

//
class HeartRateFailedState extends HealthState {}
