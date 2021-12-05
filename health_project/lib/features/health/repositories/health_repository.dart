import 'dart:convert';

import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/models/bmi_dto.dart';
import 'package:http/http.dart' as http;

class HealthRepository extends BaseApiClient {
  final http.Client httpClient;

  const HealthRepository({required this.httpClient});

  //
  Future<BMIDTO> getBMIInformation(int accountId) async {
    final String url = '/personal/bmi?id=$accountId';
    BMIDTO bmiDTO = BMIDTO(gender: 'n/a', height: 0, weight: 0, id: 0);
    try {
      final response = await getApi(url);
      if (response.statusCode == 200) {
        bmiDTO = BMIDTO.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Error at get BMI Information: $e');
    }
    return bmiDTO;
  }

  Future<bool> updateBMI(BMIDTO dto) async {
    final String url = '/personal/bmi';
    bool check = false;
    try {
      final response = await postApi(url, dto.toJson());
      if (response.statusCode == 200) {
        check = true;
      }
    } catch (e) {
      print('Error at updateBMI: $e');
    }
    return check;
  }
}
