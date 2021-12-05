import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:health_project/commons/constants/base_api.dart';
import 'package:health_project/models/custom_http_res_dto.dart';
import 'package:health_project/models/location_dto.dart';
import 'package:health_project/models/weather_dto.dart';
import 'package:health_project/models/weather_search_dto.dart';
import 'package:http/http.dart' as http;

class WeatherRepository {
  final http.Client httpClient;

  const WeatherRepository({required this.httpClient});

  //search location weather
  Future<List<WeatherSearchDTO>> searchWeather(String keyword) async {
    final url = '/search/?query=$keyword';
    Map<String, String> header = {
      'url': BASE_URL_WEATHER + url,
      'token': '',
    };
    List<WeatherSearchDTO> result = [];
    final CustomHttpResponse response =
        await compute(APIClient.getAPIWithIsolate, header);
    if (response.statusCode == 200) {
      result = await compute(parseToWeatherSearchDTO, response.bodyBytes);
    }
    return result;
  }

  //get weather information
  Future<WeatherDTO> getWeather(String latitude, String longtitude) async {
    //url and header for getting woeid
    final urlPosition = '/search/?lattlong=$latitude,$longtitude';
    Map<String, String> headerPosition = {
      'url': BASE_URL_WEATHER + urlPosition,
      'token': '',
    };
    int woeid = 0;
    final CustomHttpResponse responseLocation =
        await compute(APIClient.getAPIWithIsolate, headerPosition);
    if (responseLocation.statusCode == 200) {
      woeid = await compute(getWoeid, responseLocation.body);
    }
    WeatherDTO weatherDTO = await getWeatherByWoeid(woeid);
    return weatherDTO;
  }

  Future<WeatherDTO> getWeatherByWoeid(int woeid) async {
    WeatherDTO weatherDTO = WeatherDTO(
      consolidatedWeather: [],
      time: 'n/a',
      sunRise: 'n/a',
      sunSet: 'n/a',
      timezoneName: 'n/a',
      parent: Parent(
        title: 'n/a',
        lattLong: 'n/a',
        locationType: 'n/a',
        woeid: 0,
      ),
      sources: [],
      title: 'n/a',
      locationType: 'n/a',
      woeid: 0,
      lattLong: 'n/a',
      timezone: 'n/a',
    );
    final urlWeather = '/$woeid';
    Map<String, String> headerWeather = {
      'url': BASE_URL_WEATHER + urlWeather,
      'token': '',
    };
    final CustomHttpResponse responseWeather =
        await compute(APIClient.getAPIWithIsolate, headerWeather);
    if (responseWeather.statusCode == 200) {
      weatherDTO = await compute(parseToWeatherDTO, responseWeather.bodyBytes);
    }
    return weatherDTO;
  }

  //parse Json to list and get woeid (or DTO)
  static int getWoeid(String resBody) {
    final data = jsonDecode(resBody).cast<Map<String, dynamic>>();
    LocationDTO locationDTO = LocationDTO.fromJson(data[0]);
    return locationDTO.woeid;
  }

  //parse Json to WeatherDTO
  static WeatherDTO parseToWeatherDTO(Uint8List resBody) {
    final data = json.decode(utf8.decode(resBody));
    return WeatherDTO.fromJson(data);
  }

  static List<WeatherSearchDTO> parseToWeatherSearchDTO(Uint8List resBody) {
    final data = jsonDecode(utf8.decode(resBody)).cast<Map<String, dynamic>>();
    return data
        .map<WeatherSearchDTO>((json) => WeatherSearchDTO.fromJson(json))
        .toList();
  }
}
