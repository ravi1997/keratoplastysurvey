import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/error_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HiveInterface {
  Map<String, Box> collection;

  HiveInterface({required this.collection});

  Box? getBoxbyName(String name) {
    return collection[name];
  }
}

Future<String> getProjectName() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String projectName = packageInfo.appName;
  return projectName;
}

Map<String, dynamic> anstoFlat() {
  Map<String, dynamic> result = {};

  for (var value in ans['data']) {
    result[value['variable']] = value["value"];
  }

  ans['recorderID'] = ans['recorderID'];
  ans["surveryId"] = ans["surveryId"];
  ans["STATUS"] = "CREATED";
  ans["createAt"] = ans['CREATE-DATE-TIME'];

  return result;
}

class MyHttp {
  static const int timeout = 10;
  static String token = "";

  static Map<String, String> headers = {
    'Content-Type': 'application/json',
    'api-key': configuration!.apiKey
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

class API {
  static Future<void> storeUser(HiveInterface hiveInterface) async {
    final userBox = hiveInterface.getBoxbyName('user');
    while (userBox!.length > 0) {
      userBox.deleteAt(0);
    }
    await userBox.add(user.toJson());
  }

  static Future<void> loadUser(HiveInterface hiveInterface) async {
    final userBox = hiveInterface.getBoxbyName('user');
    user = User.fromJson(Map<String, dynamic>.from(userBox!.getAt(0) as Map));
  }

  static Future<void> loadData() async {}

  static Future<void> sync({required HiveInterface hiveInterface}) async {
    try {
      surveys.clear();
      MyHttp.token = user.token ?? "";
      final response = await MyHttp.post(configuration!.readSurvey, {});
      if (response.statusCode == 200) {
        final surveyBox = hiveInterface.getBoxbyName('survey');
        while (surveyBox!.length > 0) {
          surveyBox.deleteAt(0);
        }
        final data = jsonDecode(response.body);
        for (var survey in data['Surveys']) {
          surveys.add(Survey.fromJson(survey));
          uploadSurvey(hiveInterface: hiveInterface, survey: survey);
        }
      } else {
        surveys = getSurveyData(hiveInterface: hiveInterface);
      }
    } catch (e, stack) {
      if (kDebugMode) {
        print(stack);
        print(e);
      }
      surveys = getSurveyData(hiveInterface: hiveInterface);
    }
  }

  static Future<void> storeAnswer(HiveInterface hiveInterface) async {
    final answersBox = hiveInterface.getBoxbyName('answers');
    answersBox?.add(ans);
  }

  static Future<String> login() async {
    final body = {'loginId': user.loginId, 'password': user.password};

    final response = await MyHttp.post(configuration!.login, body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      user = User.fromJson(data['user']);
      return data['token'];
    } else {
      final errorMessage = 'Login Failed: ${response.statusCode}';
      navKey.currentState?.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/ErrorPage"),
          builder: (context) => ErrorPage(errorMessage: errorMessage),
        ),
      );

      return "";
    }
  }

  static void logout() async {
    final body = {};

    MyHttp.token = user.token ?? "";

    final response = await MyHttp.post(configuration!.logout, body);

    if (response.statusCode != 200) {
      final errorMessage =
          'Logout Failed: ${response.statusCode} ${jsonDecode(response.body)}';
      navKey.currentState?.push(
        // Use appropriate context for navigation
        MaterialPageRoute(
          settings: const RouteSettings(name: "/ErrorPage"),
          builder: (context) => ErrorPage(errorMessage: errorMessage),
        ),
      );
    }
  }

  static Future<List<String>> getDistrict() async {
    var url = configuration!.district; // Replace with your API endpoint

    var headers = {
      'Authorization': 'Bearer ${user.token}',
      'api-key': configuration!.apiKey
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse is List) {
        List<dynamic> dataList = jsonResponse;
        List<String> stringList =
            dataList.map((item) => item.toString()).toList();
        return stringList;
      } else {
        if (kDebugMode) {
          print('Invalid response format. Expected a JSON list.');
        }
      }
    } else {
      // Request failed
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}.');
      }
    }

    // Return an empty list if there is an error or the response is not a list
    return [];
  }

  static List<Map<dynamic, dynamic>> getData(
      {required HiveInterface hiveInterface,
      String? surveyId,
      required SurveyPageMode mode}) {
    final answersBox = hiveInterface.getBoxbyName('answers');

    List<Map<dynamic, dynamic>> answers = [];
    for (int i = 0; i < answersBox!.length; i++) {
      if (answersBox.getAt(i)['SURVEY-ID'] == surveyId) {
        if ((mode == SurveyPageMode.view &&
                answersBox.getAt(i)['STATUS'] == 'CREATED') ||
            (mode == SurveyPageMode.upload &&
                answersBox.getAt(i)['STATUS'] == 'UPLOADED') ||
            (mode == SurveyPageMode.delete &&
                answersBox.getAt(i)['STATUS'] == 'DELETED')) {
          answers.add(answersBox.getAt(i));
        }
      }
    }

    return answers;
  }

  static void deleteData(
      {required HiveInterface hiveInterface, required String? peopleID}) {
    final answersBox = hiveInterface.getBoxbyName('answers');
    int index = 0;
    for (int i = 0; i < answersBox!.length; i++) {
      if (answersBox.getAt(i)['ID'] == peopleID) {
        index = i;
      }
    }
    var myans = answersBox.getAt(index);
    myans['STATUS'] = 'DELETED';
    answersBox.putAt(index, myans);
  }

  static void upload(
      {required HiveInterface hiveInterface,
      List<Map<dynamic, dynamic>>? datas}) {
    final answersBox = hiveInterface.getBoxbyName('answers');
    for (var data in datas!) {
      int index = 0;
      for (int i = 0; i < answersBox!.length; i++) {
        if (answersBox.getAt(i)['ID'] == data['ID']) {
          index = i;
        }
      }
      var myans = answersBox.getAt(index);
      myans['STATUS'] = 'UPLOADED';
      answersBox.putAt(index, myans);
    }
  }

  static void uploadSurvey(
      {required HiveInterface hiveInterface,
      required Map<String, dynamic> survey}) {
    final surveyBox = hiveInterface.getBoxbyName('survey');
    surveyBox?.add(survey);
  }

  static List<Survey> getSurveyData({required HiveInterface hiveInterface}) {
    final surveyBox = hiveInterface.getBoxbyName('survey');
    List<Survey> result = [];
    for (int i = 0; i < surveyBox!.length; i++) {
      //print(surveyBox.getAt(i));
      result.add(Survey.fromJson(
          Map<String, dynamic>.from(surveyBox.getAt(i) as Map)));
    }
    return result;
  }

  static Map<String, dynamic> createAnswer() async {
    final body = anstoFlat();

    final response = await MyHttp.post(
        '${configuration!.createAnswer}/${body['surveryId']}', body);

    final data = jsonDecode(response.body);
    if (kDebugMode) {
      print(data['message']);
    }
    return data['script_message'];
  }

  static Future<bool> uploadAnswers({required List<Map> datas}) async {
    final body = {'mydata': datas};

    final response = await MyHttp.post(configuration!.uploadAnswers, body);

    final data = jsonDecode(response.body);
    if (kDebugMode) {
      print(data['message']);
    }
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
