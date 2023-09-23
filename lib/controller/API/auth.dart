import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/myhttp.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/error_page.dart';

class Auth {
  Future<String> login() async {
    final body = {'loginID': user.loginId, 'password': user.password};

    final response = await MyHttp.post(configuration.route.login, body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      user = User.fromJson(data['user']);
      return data['access_token'];
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

  void logout() async {
    final body = {};

    MyHttp.token = user.token ?? "";

    final response = await MyHttp.get(configuration.route.logout);

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
}
