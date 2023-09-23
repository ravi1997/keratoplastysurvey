import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/hive_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/survey_form_page.dart';
import 'package:keratoplastysurvey/widget/create_question.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;

class CreateSection extends StatefulWidget {
  const CreateSection(
      {super.key,
      required this.hiveInterface,
      required this.survey,
      required this.sectionIndex,
      required this.mode});
  final int sectionIndex;
  final Survey survey;
  final my_hive_interface.HiveInterface hiveInterface;
  final SurveyPageMode mode;

  @override
  State<CreateSection> createState() => _CreateSectionState();
}

class _CreateSectionState extends State<CreateSection> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> questions = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      final section = widget.survey.sections[widget.sectionIndex];
      questions = [];

      for (var question in section.questions) {
        questions.add(
            createQuestion(question, callback: setState, mode: widget.mode,survey: widget.survey,currentSectionId:widget.sectionIndex ));
      }
      if (section.finalSection != null) {
        final fSection = section.finalSection ?? false;
        if (fSection) {
          questions.add(ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();

                ans['recorderID'] = user.id;
                ans["surveryId"] = widget.survey.surveyID;
                ans["STATUS"] = "CREATED";
                ans["CREATE-DATE-TIME"] = DateTime.now().toIso8601String();

                await my_api.API.toHive.storeAnswer(widget.hiveInterface);
                final scriptMessage = await my_api.API.answerapi.insertAnswer();
                print(scriptMessage);
                navKey.currentState?.popUntil(
                    ModalRoute.withName('/${widget.survey.surveyID}'));
              }
            },
            child: const Text('Submit'),
          ));
        }
      } else {
        questions.add(ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              for (var jump
                  in widget.survey.sections[widget.sectionIndex].jumps) {
                if (jump.condition != null) {
                  if (jump.condition!.solve(ans)) {
                    navKey.currentState?.push(
                      MaterialPageRoute(
                          settings: RouteSettings(
                              name:
                                  "/${widget.survey.surveyID}/${widget.survey.sections.where((element) => element.sectionID == jump.sectionID).first.sectionID}"),
                          builder: (context) => SurveyFormPage(
                                hiveInterface: widget.hiveInterface,
                                survey: widget.survey,
                                sectionIndex: widget.survey.sections.indexWhere(
                                    (element) =>
                                        element.sectionID == jump.sectionID),
                                mode: widget.mode,
                              )),
                    );
                    break;
                  }
                  continue;
                } else {
                  navKey.currentState?.push(
                    MaterialPageRoute(
                        settings: RouteSettings(
                            name:
                                "/${widget.survey.surveyID}/${widget.survey.sections.where((element) => element.sectionID == jump.sectionID).first.sectionID}"),
                        builder: (context) => SurveyFormPage(
                              hiveInterface: widget.hiveInterface,
                              survey: widget.survey,
                              sectionIndex: widget.survey.sections.indexWhere(
                                  (element) =>
                                      element.sectionID == jump.sectionID),
                              mode: widget.mode,
                            )),
                  );
                  break;
                }
              }
            }
          },
          child: const Text('Next'),
        ));
      }
    });

    return Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: questions)));
  }
}
