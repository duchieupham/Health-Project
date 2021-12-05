import 'dart:convert';

import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/models/notification_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:http/http.dart' as http;

class NotificationRepository extends BaseApiClient {
  final http.Client httpClient;
  const NotificationRepository({required this.httpClient});

  Future<int> getUnreadCountNotificationByAccountId(int accountId) async {
    final url = '/notification/unread/$accountId';
    int result = 0;
    final request = await getApi(url);
    if (request.statusCode == 200) {
      result = int.parse(request.body);
    }
    return result;
  }

  Future<List<NotificationDTO>> getListNotificationByAccountId(
      int accountId) async {
    final url = '/notification/$accountId';
    List<NotificationDTO> list = [];
    final response = await getApi(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      list = responseData.map((e) => NotificationDTO.fromJson(e)).toList();
    }
    return list;
  }

  Future<bool> updateNotificationStatus(int notiId) async {
    Uri uri = Uri.parse('$BASE_URL/notification/read');
    final request = http.MultipartRequest('POST', uri);
    request.headers['authorization'] =
        AuthenticateHelper.instance.getTokenAccount();
    request.fields['id'] = '$notiId';
    final response = await request.send();
    return (response.statusCode == 200) ? true : false;
  }
}
