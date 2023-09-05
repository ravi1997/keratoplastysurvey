import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/pages/login_page.dart';

Widget logoutButton(my_api.HiveInterface hiveInterface) {
  return IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () async {
      my_api.API.logout();
      await my_api.API.loadUser(hiveInterface);
      navKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
              settings: const RouteSettings(name: "/LoginPage"),
              builder: (context) => LoginPage(
                    hiveInterface: hiveInterface,
                  )),
          (Route<dynamic> route) => false);
    },
  );
}
