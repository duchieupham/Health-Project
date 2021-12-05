import 'package:equatable/equatable.dart';
import 'package:health_project/models/account_contact_dto.dart';
import 'package:health_project/models/account_personal_dto.dart';

abstract class PersonalEvent extends Equatable {
  const PersonalEvent();
}

class PersonalEventGet extends PersonalEvent {
  final int id;

  const PersonalEventGet({required this.id});

  @override
  List<Object> get props => [id];
}

class PersonalEventUpdatePassword extends PersonalEvent {
  final int id;
  final String username;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  const PersonalEventUpdatePassword({
    required this.id,
    required this.username,
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  @override
  List<Object> get props =>
      [id, username, oldPassword, newPassword, confirmPassword];
}

class PersonalEventUpdateInfor extends PersonalEvent {
  final AccountPersonalDTO dto;

  const PersonalEventUpdateInfor({required this.dto});

  @override
  List<Object> get props => [dto];
}

class PersonalEventUpdateContact extends PersonalEvent {
  final bool isConfirmedPhone;
  final AccountContactDTO dto;

  const PersonalEventUpdateContact(
      {required this.isConfirmedPhone, required this.dto});

  @override
  List<Object> get props => [isConfirmedPhone, dto];
}

class PersonalEventConfirmPhoneNumber extends PersonalEvent {
  final String phoneNumber;
  const PersonalEventConfirmPhoneNumber({required this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
}

class PersonalEventConfirmOTP extends PersonalEvent {
  final String otp;
  const PersonalEventConfirmOTP({required this.otp});
  @override
  List<Object> get props => [otp];
}
