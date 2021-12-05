import 'package:equatable/equatable.dart';
import 'package:health_project/commons/constants/enum.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginProcessingState extends LoginState {}

class LoginFirebaseSuccess extends LoginState {}

class LoginSuccessState extends LoginState {}

class LoginFailedState extends LoginState {
  final LoginErrorType type;
  final String msg;
  const LoginFailedState({required this.type, required this.msg});

  @override
  List<Object> get props => [type, msg];
}
