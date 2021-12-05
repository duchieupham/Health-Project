import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/firebase/firebase_authentication.dart';
import 'package:health_project/commons/utils/login_validator.dart';
import 'package:health_project/features/login/events/login_event.dart';
import 'package:health_project/features/login/repositories/account_repository.dart';
import 'package:health_project/features/login/states/login_state.dart';
import 'package:health_project/models/account_dto.dart';
import 'package:crypto/crypto.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AccountRepository accountRepository;
  LoginBloc({required this.accountRepository}) : super(LoginInitialState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      yield LoginLoadingState();
      if (event is LoginByAccountEvent) {
        if (!LoginValidator.instance.isValidUsername(event.username) &&
            !LoginValidator.instance.isValidPassword(event.password))
          yield LoginFailedState(
            type: LoginErrorType.ACCOUNT_ERR,
            msg: 'Tên đăng nhập và mật khẩu không hợp lệ.',
          );
        else if (!LoginValidator.instance.isValidUsername(event.username))
          yield LoginFailedState(
            type: LoginErrorType.ACCOUNT_ERR,
            msg: 'Tên đăng nhập không hợp lệ.',
          );
        else if (!LoginValidator.instance.isValidPassword(event.password))
          yield LoginFailedState(
            type: LoginErrorType.ACCOUNT_ERR,
            msg: 'Mật khẩu không hợp lệ.',
          );
        else {
          yield LoginProcessingState();
          //hash password (HMAC SHA-256, username for key and password for data)
          List<int> key = utf8.encode(event.username);
          List<int> data = utf8.encode(event.password);

          Hmac hmacSHA256 = Hmac(sha256, key);
          Digest password = hmacSHA256.convert(data);

          //do login into system
          bool check = await accountRepository.checkLogin(
            AccountDTO(
              username: event.username,
              password: password.toString(),
              isLoginPhone: false,
              phone: '',
            ),
          );
          if (check)
            yield LoginSuccessState();
          else
            yield LoginFailedState(
              type: LoginErrorType.ACCOUNT_ERR,
              msg: 'Tài khoản hiện không có trong hệ thống.',
            );
        }
      }
      if (event is LoginByPhoneEvent) {
        if (!LoginValidator.instance.isValidPhone(event.phone))
          yield LoginFailedState(
            type: LoginErrorType.PHONE_ERR,
            msg: 'Số điện thoại không hợp lệ.',
          );
        else {
          //login into firebase
          await FirebaseAuthentication.instance.verifyPhoneNumber(event.phone);
          yield LoginFirebaseSuccess();
        }
      }
      if (event is CheckOTPCodeEvent) {
        yield LoginProcessingState();
        //check otp code is valid
        SignInMessage msg = await FirebaseAuthentication.instance
            .confirmPhoneNumber(event.code);
        if (msg == SignInMessage.SUCCESS) {
          //do login into sytem
          bool check = await accountRepository.checkLogin(
            AccountDTO(
              username: '',
              password: '',
              isLoginPhone: true,
              phone: event.phone,
            ),
          );
          if (check)
            yield LoginSuccessState();
          else
            yield LoginFailedState(
              type: LoginErrorType.ACCOUNT_ERR,
              msg: 'Tài khoản hiện không có trong hệ thống.',
            );
        } else if (msg == SignInMessage.WRONG_OTP)
          yield LoginFailedState(
            type: LoginErrorType.PHONE_ERR,
            msg:
                'Mã OTP không đúng hoặc hết hạn. Vui lòng kiểm tra lại mã hoặc yêu cầu gửi lại.',
          );
        else
          yield LoginFailedState(
            type: LoginErrorType.PHONE_ERR,
            msg:
                'Kiểm tra lại kết nối hoặc thử đăng nhập bằng tài khoản Health.',
          );
      }
    } catch (e) {
      print('Error at login bloc: $e');
      yield LoginFailedState(
        type: LoginErrorType.ACCOUNT_ERR,
        msg: 'Kiểm tra lại kết nối.',
      );
    }
  }
}
