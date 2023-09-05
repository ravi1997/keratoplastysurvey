import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/widget/create_section.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/widget/logout_button.dart';

class SurveyFormPage extends StatefulWidget {
  const SurveyFormPage(
      {super.key,
      required this.hiveInterface,
      required this.survey,
      required this.mode,
      this.sectionIndex});
  final my_api.HiveInterface hiveInterface;
  final int? sectionIndex;
  final SurveyPageMode mode;

  final Survey survey;

  @override
  State<SurveyFormPage> createState() => _SurveyFormPageState();
}

class _SurveyFormPageState extends State<SurveyFormPage> {
  @override
  Widget build(BuildContext context) {
    final section = widget.survey.sections[widget.sectionIndex ?? 0];

    return Scaffold(
        appBar: AppBar(
          title: Text(section.sectionName),
          actions: [logoutButton(widget.hiveInterface)],
        ),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          child: CreateSection(
            hiveInterface: widget.hiveInterface,
            survey: widget.survey,
            sectionIndex: widget.sectionIndex ?? 0,
            mode: widget.mode,
          ),
        ));
  }
}
