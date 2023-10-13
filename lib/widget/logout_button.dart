import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/configuration.dart' as config;
import 'package:keratoplastysurvey/controller/local_store_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/pages/login_page.dart';

Widget logoutButton(my_hive_interface.LocalStoreInterface hiveInterface) {
  return IconButton(
    icon: const Icon(Icons.logout),
    onPressed: () {
      my_api.API.auth.logout();
      my_api.API.fromFile.loadUser(hiveInterface);
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
