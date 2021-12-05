//Object CustomHttpResponse is used for compute() - other thread/isolate.
import 'dart:typed_data';

class CustomHttpResponse {
  final String body;
  final int statusCode;
  final Uint8List bodyBytes;
  //you can add more attributes that you need.
  //final Map<String, String>? headers;

  const CustomHttpResponse({
    required this.body,
    required this.statusCode,
    required this.bodyBytes,
  });
}
