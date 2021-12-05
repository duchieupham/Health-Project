import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/models/event_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:http/http.dart' as http;

class CalendarRepository extends BaseApiClient {
  final http.Client httpClient;

  const CalendarRepository({required this.httpClient});

  Future<List<EventDTO>> getEventsByPatientId(int patientId) async {
    final String url = '/events/$patientId';
    Map<String, String> header = {
      'url': BASE_URL + url,
      'token': AuthenticateHelper.instance.getTokenAccount(),
    };
    List<EventDTO> list = [];
    final response = await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      list = await compute(parseToEventDTO, response.body);
    }
    return list;
  }

  //parse Json to EventDTO
  static List<EventDTO> parseToEventDTO(String resBody) {
    final data = jsonDecode(resBody).cast<Map<String, dynamic>>();
    return data.map<EventDTO>((json) => EventDTO.fromJson(json)).toList();
  }
}
