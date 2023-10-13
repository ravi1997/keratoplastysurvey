import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/local_store_interface.dart';
import 'package:keratoplastysurvey/widget/logout_button.dart';
import 'package:keratoplastysurvey/widget/survey_list.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage(
      {super.key, required this.hiveInterface, required this.mode});
  final LocalStoreInterface hiveInterface;
  final SurveyPageMode mode;

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Survey"),
          actions: [
            logoutButton(widget.hiveInterface),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: SurveyList(
              hiveInterface: widget.hiveInterface, mode: widget.mode),
        ));
  }
}
