import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/configuration.dart' as config;
import 'package:keratoplastysurvey/controller/hive_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/pages/login_page.dart';

Widget logoutButton(my_hive_interface.HiveInterface hiveInterface) {
  return IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () async {
      my_api.API.auth.logout();
      await my_api.API.fromHive.loadUser(hiveInterface);
      config.navKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(
              settings: const RouteSettings(name: "/LoginPage"),
              builder: (context) => LoginPage(
                    hiveInterface: hiveInterface,
                  )),
          (Route<dynamic> route) => false);
    },
  );
}
