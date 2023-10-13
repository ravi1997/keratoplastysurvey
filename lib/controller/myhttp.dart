import 'package:keratoplastysurvey/configuration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';


class Multipart{
  static const int timeout = 5;
  static String token = "";

  static Map<String, String> headers = {
    'api-key': configuration.apiKey
  };

  Future<dynamic> post(url, jsonBody,files) async {
    headers['Authorization'] = 'Bearer $token';
    headers['api-key'] = configuration.apiKey;

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields['json_data'] = jsonEncode(jsonBody);

    for (var filePath in files) {
      // Extract the original file name from the path
      String originalFileName = filePath.split('/').last;

      // Create an MultipartFile with the original file name
      request.files.add(
        http.MultipartFile(
          'files', // Field name for files on the server
          File(filePath).readAsBytes().asStream(),
          File(filePath).lengthSync(),
          filename: originalFileName,
          contentType: MediaType('application', 'octet-stream'), // Set the appropriate content type
        ),
      );
    }

    return request.send().timeout(
      const Duration(
        seconds: Multipart.timeout
      ) ,
      onTimeout: () {
        throw "TimeOut";
      },
    );
  }

  Future<dynamic> put(url, jsonBody,files) async {
    headers['Authorization'] = 'Bearer $token';
    headers['api-key'] = configuration.apiKey;

    var request = http.MultipartRequest('PUT', Uri.parse(url));
    request.headers.addAll(headers);
    request.fields['json_data'] = jsonEncode(jsonBody);

    for (var filePath in files) {
      // Extract the original file name from the path
      String originalFileName = filePath.split('/').last;

      // Create an MultipartFile with the original file name
      request.files.add(
        http.MultipartFile(
          'files', // Field name for files on the server
          File(filePath).readAsBytes().asStream(),
          File(filePath).lengthSync(),
          filename: originalFileName,
          contentType: MediaType('application', 'octet-stream'), // Set the appropriate content type
        ),
      );
    }

    return request.send().timeout(
      const Duration(
          seconds: Multipart.timeout
      ) ,
      onTimeout: () {
        throw "TimeOut";
      },
    );
  }

}

class MyHttp {
  static const int timeout = 10;
  static String token = "";

  static Multipart multipart = Multipart();

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
