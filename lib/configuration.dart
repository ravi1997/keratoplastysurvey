import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:uuid/uuid.dart';

enum SurveyPageMode { entry, view, edit, delete, upload, admin }

Map<String, dynamic> ans = {};
User user = User(
    name: "", loginId: "", password: "", rememberMe: false, signedIn: false);

List<Survey> surveys = [];
var uuid = const Uuid();
List<String> variables = [];

final navKey = GlobalKey<NavigatorState>();

class Configuration {
  final String baseURL;
  String get district => '$baseURL/district';
  String get cluster => '$baseURL/cluster';
  String get login => '$baseURL/auth/login';
  String get logout => '$baseURL/auth/logout';
  String get readSurvey => '$baseURL/survey/read';
  String get createAnswer => '$baseURL/answer/insert_data';
  String get uploadAnswers => '$baseURL/answer/create_all';

  String get sync => '$baseURL/sync';

  final String apiKey = 'my secret key';

  Configuration({required this.baseURL});
}

Configuration? configuration;
