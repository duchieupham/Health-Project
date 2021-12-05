import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/commons/firebase/firebase_authentication.dart';
import 'package:health_project/commons/utils/array_validator.dart';
import 'package:health_project/features/personal/events/personal_event.dart';
import 'package:health_project/features/personal/repositories/personal_repository.dart';
import 'package:health_project/features/personal/states/personal_state.dart';
import 'package:health_project/models/account_information_dto.dart';
import 'package:crypto/crypto.dart';
import 'package:health_project/models/account_password_dto.dart';
import 'package:health_project/services/authentication_helper.dart';

class PersonalBloc extends Bloc<PersonalEvent, PersonalState> {
  final PersonalRepository personalRepository;
  PersonalBloc({required this.personalRepository})
      : super(PersonalInitialState());

  @override
  Stream<PersonalState> mapEventToState(PersonalEvent event) async* {
    //
    try {
      yield PersonalLoadingState();
      // get information event
      if (event is PersonalEventGet) {
        AccountInformationDTO accountInformationDTO =
            await personalRepository.getInformationAccount(event.id);
        yield PersonalLoadSuccessState(dto: accountInformationDTO);
      }
      // update password event
      if (event is PersonalEventUpdatePassword) {
        if (event.confirmPassword != event.newPassword) {
          yield PersonalUpdateFailState(
              type: PersonalUpdateMsgType.NOT_MATCH_PASSWORD);
        } else {
          if (event.newPassword == '') {
            yield PersonalUpdateFailState(
                type: PersonalUpdateMsgType.EMPTY_NEW_PASSWORD);
          } else {
            //hash password (HMAC SHA-256, username for key and password for data)
            List<int> key = utf8.encode(event.username);
            List<int> oldData = utf8.encode(event.oldPassword);
            List<int> newData = utf8.encode(event.newPassword);

            Hmac hmacSHA256 = Hmac(sha256, key);
            Digest generatedOldPassword = hmacSHA256.convert(oldData);
            Digest generatedNewPassword = hmacSHA256.convert(newData);

            //Account password DTO
            AccountPasswordDTO dto = AccountPasswordDTO(
                id: event.id,
                oldPassword: generatedOldPassword.toString(),
                newPassword: generatedNewPassword.toString());

            PersonalUpdateMsgType msg =
                await personalRepository.updatePasswordAccount(dto);
            if (msg == PersonalUpdateMsgType.OK) {
              yield PersonalUpdateSuccessState();
            } else {
              yield PersonalUpdateFailState(type: msg);
            }
          }
        }
      }
      // update personal information
      if (event is PersonalEventUpdateInfor) {
        //check fullname
        if (ArrayValidator.instance
            .isValidName(event.dto.firstname, event.dto.lastname)) {
          //check birthday
          if (ArrayValidator.instance.isValidBirthday(event.dto.birthday)) {
            bool check =
                await personalRepository.updatePersonalAccount(event.dto);
            if (check) {
              yield PersonalUpdateSuccessState();
            }
          } else {
            yield PersonalUpdateFailState(
                type: PersonalUpdateMsgType.INVALID_BIRTHDAY);
          }
        } else {
          yield PersonalUpdateFailState(
              type: PersonalUpdateMsgType.INVALID_NAME);
        }
      }

      // confirm phone number event
      if (event is PersonalEventConfirmPhoneNumber) {
        if (ArrayValidator.instance.isValidPhone(event.phoneNumber)) {
          // Send OTP Code
          await FirebaseAuthentication.instance
              .verifyPhoneNumber(event.phoneNumber);
          yield PersonalSendOTPCodeState();
        } else {
          yield PersonalUpdateFailState(
              type: PersonalUpdateMsgType.INVALID_PHONE);
        }
      }

      //confirm otp event
      if (event is PersonalEventConfirmOTP) {
        SignInMessage msg =
            await FirebaseAuthentication.instance.confirmPhoneNumber(event.otp);
        if (msg == SignInMessage.SUCCESS) {
          yield PersonalConfirmedOTPState(
              type: PersonalUpdateMsgType.CONFIRMED_OTP);
        } else if (msg == SignInMessage.WRONG_OTP) {
          yield PersonalUpdateFailState(type: PersonalUpdateMsgType.WRONG_OTP);
        } else {
          yield PersonalUpdateFailState(type: PersonalUpdateMsgType.DISCONNECT);
        }
      }

      //update contact event
      if (event is PersonalEventUpdateContact) {
        if (event.isConfirmedPhone) {
          //phone is confirmed (otp code is, too) Check validAddress and update
          if (ArrayValidator.instance.isValidAddress(event.dto.address)) {
            bool check =
                await personalRepository.updateContactAccount(event.dto);
            if (check) {
              yield PersonalUpdateSuccessState();
            }
          } else {
            yield PersonalUpdateFailState(
                type: PersonalUpdateMsgType.INVALID_ADDRESS);
          }
        } else {
          yield PersonalUpdateFailState(
              type: PersonalUpdateMsgType.NOT_CONFIRM_PHONE);
        }
      }

      //reload Information view when update successful
      if (state is PersonalUpdateSuccessState) {
        this.add(
            PersonalEventGet(id: AuthenticateHelper.instance.getAccountId()));
      }
    } catch (e) {
      print('Error at Personal bloc: $e');
      yield PersonalUpdateFailState(type: PersonalUpdateMsgType.DISCONNECT);
    }
  }
}
