import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/configuration.dart';

import 'package:keratoplastysurvey/pages/survey_page.dart';
import 'package:keratoplastysurvey/widget/logout_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.hiveInterface});
  final my_api.HiveInterface hiveInterface;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
          actions: [logoutButton(widget.hiveInterface)],
        ),
        body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            if (user.type == "ADMIN")
              const SizedBox(
                height: 10.0,
              ),
            if (user.type == "ADMIN")
              ElevatedButton(
                  onPressed: () {}, child: const Text('Admin panel')),
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
                child: const Text('Survey Entry')),
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
                child: const Text('Get Survey Details')),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  navKey.currentState?.push(MaterialPageRoute(
                      settings: const RouteSettings(name: "/SurveryPage"),
                      builder: (context) => SurveyPage(
                            hiveInterface: widget.hiveInterface,
                            mode: SurveyPageMode.upload,
                          )));
                },
                child: const Text('Uploaded Details')),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
                onPressed: () {
                  navKey.currentState?.push(MaterialPageRoute(
                      settings: const RouteSettings(name: "/SurveryPage"),
                      builder: (context) => SurveyPage(
                            hiveInterface: widget.hiveInterface,
                            mode: SurveyPageMode.delete,
                          )));
                },
                child: const Text('Deleted Details')),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Settings'))
          ]),
        ));
  }
}
