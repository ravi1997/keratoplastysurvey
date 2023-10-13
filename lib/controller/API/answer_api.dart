import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/myhttp.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/pages/error_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class AnswerAPI {
  Future<Map<String, dynamic>?> insertAnswer() async {
    final body = Util.anstoFlat();
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory());
      } else {
        directory = (await getApplicationDocumentsDirectory());
      }
    } catch (err) {
      if (kDebugMode) {
        print("Cannot get download folder path");
      }
    }

    String projectName = await Util.getProjectName();
    if (!Directory("${directory!.path}/$projectName").existsSync()) {
      Directory("${directory.path}/$projectName").create(recursive: true);
    }

    directory = Directory("${directory.path}/$projectName");
    var mylist = (ans['data'] as List);

    List<String> files = [];

    try {
      int index =
          mylist.indexWhere((element) => element['variable'] == "photoRE");
      String photoRE = mylist[index]["value"];
      index = mylist.indexWhere((element) => element['variable'] == "photoLE");
      String photoLE = mylist[index]["value"];

      files.add("${directory.path}/$photoLE");

      files.add("${directory.path}/$photoRE");
    } catch (e) {}

    Multipart.token = user.token ?? "";

    final response = await MyHttp.multipart
        .post(configuration.route.createAnswer, body, files);

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data['script_message'];
    } else {
      final errorMessage = 'insert Failed: ${response.statusCode}';
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

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
    MyHttp.token = user.token ?? "";

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

  Future<List<Map<String, dynamic>>?> uploadAnswer(List<Map<String, dynamic>> datas) async {
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory());
      } else {
        directory = (await getApplicationDocumentsDirectory());
      }
    } catch (err) {
      if (kDebugMode) {
        print("Cannot get download folder path");
      }
    }

    String projectName = await Util.getProjectName();
    if (!Directory("${directory!.path}/$projectName").existsSync()) {
      Directory("${directory.path}/$projectName").create(recursive: true);
    }

    directory = Directory("${directory.path}/$projectName");
    Multipart.token = user.token ?? "";
    List<String> files = [];
    var body = [];

    for (var data in datas) {
      ans = data;
      final body_data = Util.anstoFlat();
      var mylist = (ans['data'] as List);

      try {
        int index =
            mylist.indexWhere((element) => element['variable'] == "photoRE");
        String photoRE = mylist[index]["value"];
        index =
            mylist.indexWhere((element) => element['variable'] == "photoLE");
        String photoLE = mylist[index]["value"];


        files.add("${directory.path}/$photoLE");

        files.add("${directory.path}/$photoRE");
      } catch (e) {}


      body.add(body_data);

    }

    final response = await MyHttp.multipart
        .put(configuration.route.uploadAnswers, body, files);

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);
      return data['script_message'];
    } else {
      final errorMessage = 'insert Failed: ${response.statusCode}';
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

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
