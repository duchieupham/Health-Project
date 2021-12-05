import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginByAccountEvent extends LoginEvent {
  final String username;
  final String password;

  const LoginByAccountEvent({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

class LoginByPhoneEvent extends LoginEvent {
  final String phone;
  const LoginByPhoneEvent({required this.phone});

  @override
  List<Object> get props => [phone];
}

class CheckOTPCodeEvent extends LoginEvent {
  final String code;
  final String phone;
  const CheckOTPCodeEvent({required this.code, required this.phone});

  @override
  List<Object> get props => [code, phone];
}
