import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/hive_interface.dart';

import 'package:keratoplastysurvey/pages/survey_page.dart';
import 'package:keratoplastysurvey/widget/logout_button.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, required this.hiveInterface});
  final HiveInterface hiveInterface;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Admin Page"),
          actions: [logoutButton(widget.hiveInterface)],
        ),
        body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  navKey.currentState?.push(MaterialPageRoute(
                      settings: const RouteSettings(name: "/SurveryPage"),
                      builder: (context) => SurveyPage(
                            hiveInterface: widget.hiveInterface,
                            mode: SurveyPageMode.entry,
                          )));
                },
                child: const Text('Survey Page')),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  navKey.currentState?.push(MaterialPageRoute(
                      settings: const RouteSettings(name: "/SurveryPage"),
                      builder: (context) => SurveyPage(
                            hiveInterface: widget.hiveInterface,
                            mode: SurveyPageMode.view,
                          )));
                },
                child: const Text('User Page')),
          ]),
        ));
  }
}
