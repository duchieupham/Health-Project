import 'dart:convert';

import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/commons/constants/enum.dart';
import 'package:health_project/models/account_contact_dto.dart';
import 'package:health_project/models/account_information_dto.dart';
import 'package:health_project/models/account_password_dto.dart';
import 'package:health_project/models/account_personal_dto.dart';
import 'package:http/http.dart' as http;

class PersonalRepository extends BaseApiClient {
  final http.Client httpClient;

  const PersonalRepository({required this.httpClient});

  //show information account
  Future<AccountInformationDTO> getInformationAccount(int id) async {
    final url = '/accounts/information?id=$id';
    final response = await getApi(url);
    AccountInformationDTO dto = AccountInformationDTO(
        username: 'n/a',
        phone: 'n/a',
        firstname: 'n/a',
        lastname: 'n/a',
        gender: 'n/a',
        birthday: 'n/a',
        address: 'n/a');
    if (response.statusCode == 200) {
      dto = AccountInformationDTO.fromJson(jsonDecode(response.body));
    }
    return dto;
  }

  //update personal account
  Future<bool> updatePersonalAccount(AccountPersonalDTO dto) async {
    bool check = false;
    final url = '/accounts/personal';
    final response = await postApi(url, dto.toJson());
    if (response.statusCode == 200) {
      check = true;
    }
    return check;
  }

  //update contact account
  Future<bool> updateContactAccount(AccountContactDTO dto) async {
    bool check = false;
    final url = '/accounts/contact';
    final response = await postApi(url, dto.toJson());
    if (response.statusCode == 200) {
      check = true;
    }
    return check;
  }

  //update password
  Future<PersonalUpdateMsgType> updatePasswordAccount(
      AccountPasswordDTO dto) async {
    PersonalUpdateMsgType type = PersonalUpdateMsgType.PROCESSING;
    final url = '/accounts/password';
    final response = await postApi(url, dto.toJson());
    if (response.statusCode == 200) {
      type = PersonalUpdateMsgType.OK;
    } else if (response.statusCode == 304) {
      type = PersonalUpdateMsgType.WRONG_OLD_PASSWORD;
    } else {
      type = PersonalUpdateMsgType.DISCONNECT;
    }
    return type;
  }
}
