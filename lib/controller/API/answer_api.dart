import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/myhttp.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/pages/error_page.dart';

class AnswerAPI {
  Future<Map<String, dynamic>?> insertAnswer() async {
    final body = Util.anstoFlat();

    final response = await MyHttp.post(configuration.route.createAnswer, body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['script_message'];
    } else {
      final errorMessage = 'Login Failed: ${response.statusCode}';
      navKey.currentState?.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/ErrorPage"),
          builder: (context) => ErrorPage(errorMessage: errorMessage),
        ),
      );

      return null;
    }
  }

  Future<Map<String, dynamic>?> updateAnswer() async {
    final body = Util.anstoFlat();

    final response = await MyHttp.post(configuration.route.updateAnswers, body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['script_message'];
    } else {
      final errorMessage = 'Login Failed: ${response.statusCode}';
      navKey.currentState?.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: "/ErrorPage"),
          builder: (context) => ErrorPage(errorMessage: errorMessage),
        ),
      );

      return null;
    }
  }
}
