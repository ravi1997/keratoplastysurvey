import 'package:keratoplastysurvey/configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHttp {
  static const int timeout = 10;
  static String token = "";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'api-key': configuration.apiKey
  };

  static Future<http.Response> get(url) async {
    headers['Authorization'] = 'Bearer $token';
    return await http
        .get(Uri.parse(url), headers: headers)
        .timeout(const Duration(seconds: timeout));
  }

  static Future<http.Response> post(url, body) async {
    headers['Authorization'] = 'Bearer $token';

    return await http
        .post(Uri.parse(url), headers: headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: timeout));
  }
}
