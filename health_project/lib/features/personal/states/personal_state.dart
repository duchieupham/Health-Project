import 'package:equatable/equatable.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/models/account_information_dto.dart';

abstract class PersonalState extends Equatable {
  const PersonalState();

  @override
  List<Object> get props => [];
}

class PersonalInitialState extends PersonalState {}

class PersonalLoadingState extends PersonalState {}

class PersonalLoadSuccessState extends PersonalState {
  final AccountInformationDTO dto;

  const PersonalLoadSuccessState({required this.dto});

  @override
  List<Object> get props => [dto];
}

class PersonalSendOTPCodeState extends PersonalState {}

class PersonalConfirmedOTPState extends PersonalState {
  final PersonalUpdateMsgType type;

  const PersonalConfirmedOTPState({required this.type});

  @override
  List<Object> get props => [type];
}

class PersonalUpdateSuccessState extends PersonalState {}

class PersonalUpdateFailState extends PersonalState {
  final PersonalUpdateMsgType type;

  const PersonalUpdateFailState({required this.type});

  @override
  List<Object> get props => [type];
}
