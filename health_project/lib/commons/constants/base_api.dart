import 'dart:convert';
import 'dart:io';
import 'package:health_project/models/custom_http_res_dto.dart';
import 'package:health_project/services/authentication_helper.dart';
import 'package:http/http.dart' as http;

//prefix url for access API
const BASE_URL = 'http://192.168.1.101:8084/api/v1';
const BASE_URL_IMAGE = 'http://192.168.1.101:8084/images';
const BASE_URL_WEATHER = 'https://www.metaweather.com/api/location';

//Base API for get data from server without using thread/isolate.
class BaseApiClient {
  static final String _token = AuthenticateHelper.instance.getTokenAccount();

  const BaseApiClient();

  Future<http.Response> getApi(String url) async {
    return await http.get(
      Uri.parse(BASE_URL + url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: _token,
      },
    );
  }

  Future<http.Response> postLoginApi(String url, dynamic body) async {
    _removeBodyNullValues(body);
    return await http.post(
      Uri.parse(BASE_URL + url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> postApi(String url, dynamic body) async {
    _removeBodyNullValues(body);
    return await http.post(
      Uri.parse(BASE_URL + url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: _token,
      },
      body: jsonEncode(body),
    );
  }

  Future<http.Response> putApi(String url, dynamic body) async {
    _removeBodyNullValues(body);
    return await http.put(
      Uri.parse(BASE_URL + url),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: _token,
      },
      body: jsonEncode(body),
    );
  }

  void _removeBodyNullValues(body) {
    if (body is Map<String, dynamic>) {
      body.removeWhere(_isMapValueNull);
    } else if (body is List<Map<String, dynamic>>) {
      body.forEach((element) => element.removeWhere(_isMapValueNull));
    }
  }

  bool _isMapValueNull(String _, dynamic value) =>
      value == null && value is! String;
}

//APIClient for get data from server using thread/isolate. Reduce heavy tasks of main thread/isolate.
class APIClient {
  const APIClient();

  static Future<CustomHttpResponse> getAPIWithIsolate(
      Map<String, String> header) async {
    final http.Response result = await http.get(
      Uri.parse(header['url']!),
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: header['token']!,
      },
    );
    CustomHttpResponse shr = CustomHttpResponse(
      body: result.body,
      statusCode: result.statusCode,
      bodyBytes: result.bodyBytes,
    );
    return shr;
  }
}
