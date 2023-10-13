import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:uuid/uuid.dart';

enum SurveyPageMode { entry, view, edit, delete, upload, admin }

Map<String, dynamic> ans = {};
User user = User(
    name: "", loginId: "", password: "", rememberMe: false, signedIn: false);

List<Survey> surveys = [];
var myuuid = const Uuid();
List<String> variables = [];

final navKey = GlobalKey<NavigatorState>();

class Configuration {
  final String apiKey = 'my secret key';
  final Route route;

  Configuration(String baseURL) : route = Route(baseURL: baseURL);
}

Configuration configuration = Configuration("");

class Route {
  final String baseURL;
  String get login => '$baseURL/auth/login';
  String get logout => '$baseURL/auth/logout';

  String get createAnswer => '$baseURL/answer/insert_data/keratoplasty';
  String get updateAnswers => '$baseURL/answer/update_data/keratoplasty';
  String get getAnswers => '$baseURL/answer/get/keratoplasty';
  String get uploadAnswers => '$baseURL/answer/upload/keratoplasty';

  Route({required this.baseURL});
}
