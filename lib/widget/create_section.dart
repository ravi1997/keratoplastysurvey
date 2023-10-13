import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/local_store_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/survey_form_page.dart';
import 'package:keratoplastysurvey/widget/create_question.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:keratoplastysurvey/controller/util.dart';

import '../pages/error_page.dart';

class CreateSection extends StatefulWidget {
  const CreateSection(
      {super.key,
      required this.hiveInterface,
      required this.survey,
      required this.sectionIndex,
      required this.mode});
  final int sectionIndex;
  final Survey survey;
  final my_hive_interface.LocalStoreInterface hiveInterface;
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
        questions.add(createQuestion(question,
            callback: setState,
            mode: widget.mode,
            survey: widget.survey,
            currentSectionId: section.sectionID,
            context: context));
      }
      if (section.finalSection != null) {
        final fSection = section.finalSection ?? false;
        if (fSection) {
          questions.add(ElevatedButton(
            onPressed: () async {
              if (widget.mode == SurveyPageMode.entry ||
                  widget.mode == SurveyPageMode.edit) {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  ans['recorderID'] = user.id;
                  ans["SURVEY-ID"] = widget.survey.surveyID;
                  ans["STATUS"] = "CREATED";
                  ans["CREATE-DATE-TIME"] = DateTime.now().toIso8601String();
                  if (widget.mode == SurveyPageMode.entry) {
                    ans["answerID"] = myuuid.v4();

                    my_api.API.toFile.storeAnswer(widget.hiveInterface);
                    try {
                      final scriptMessage =
                      await my_api.API.answerapi.insertAnswer();

                      var plist = (ans['data'] as List);
                      int index = plist.indexWhere(
                              (element) =>
                          element['variable'] == "examination");
                      if (plist[index]["value"] == 1) {
                        final leftresult = scriptMessage?['left']['type'];
                        final rightresult = scriptMessage?['right']['type'];
                        final rightconfidence = scriptMessage?['right']['type'];
                        final leftconfidence = scriptMessage?['left']['type'];

                        String kerRE = "No",
                            kerLE = "No";

                        if (plist[plist.indexWhere((
                            element) => element['variable'] == "coRE")]
                        ['value'] ==
                            1 &&
                            plist[plist.indexWhere((element) =>
                            element['variable'] == "sizeRE")]['value'] ==
                                2 &&
                            plist[plist.indexWhere((
                                element) => element['variable'] == "cpRE")]
                            ['value'] ==
                                1 &&
                            plist[plist.indexWhere((
                                element) => element['variable'] == "pinRE")]
                            ['value'] >
                                4 &&
                            plist[plist.indexWhere(
                                    (element) =>
                                element['variable'] == "pinRE")]
                            ['value'] !=
                                16) {
                          kerRE = "Yes";
                        }
                        if (plist[plist.indexWhere((
                            element) => element['variable'] == "coLE")]
                        ['value'] ==
                            1 &&
                            plist[plist.indexWhere((element) =>
                            element['variable'] == "sizeLE")]['value'] ==
                                2 &&
                            plist[plist.indexWhere((
                                element) => element['variable'] == "cpLE")]
                            ['value'] ==
                                1 &&
                            plist[plist.indexWhere((
                                element) => element['variable'] == "pinLE")]
                            ['value'] >
                                4 &&
                            plist[plist.indexWhere(
                                    (element) =>
                                element['variable'] == "pinLE")]
                            ['value'] !=
                                16) {
                          kerLE = "Yes";
                        }

                        var airesult = KeratoplastyAIResult(
                            answerID: ans["answerID"],
                            resultLE: leftresult,
                            resultRE: rightresult,
                            resultLEConfidence: leftconfidence,
                            resultREConfidence: rightconfidence);

                        my_api.API.toFile.storeAIResult(
                            widget.hiveInterface, airesult);

                        Directory? directory;
                        try {
                          if (Platform.isAndroid) {
                            directory = (await getExternalStorageDirectory());
                          } else {
                            directory =
                            (await getApplicationDocumentsDirectory());
                          }
                        } catch (err) {
                          if (kDebugMode) {
                            print("Cannot get download folder path");
                          }
                        }

                        String projectName = await Util.getProjectName();
                        if (!Directory("${directory!.path}/$projectName")
                            .existsSync()) {
                          Directory("${directory.path}/$projectName")
                              .create(recursive: true);
                        }

                        directory = Directory("${directory.path}/$projectName");
                        int index = plist.indexWhere(
                                (element) => element['variable'] == "photoRE");
                        String photoRE = plist[index]["value"];
                        index = plist.indexWhere(
                                (element) => element['variable'] == "photoLE");
                        String photoLE = plist[index]["value"];

                        bool? shouldPop = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'RESULT',
                                                style: TextStyle(
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: const Icon(
                                                    Icons.close_rounded),
                                                color: Colors.redAccent,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.70,
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.75,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: [
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      "Submitted Successfully",
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 24),
                                                    )),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      "Right Eye (A.I.)",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 8.0),
                                                    child: Text(
                                                      rightresult,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 8.0),
                                                    child: Text(
                                                      "KERATOPLASTY REQUIRED : $kerRE",
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )),
                                                Visibility(
                                                  visible: File(
                                                      "${directory
                                                          ?.path}/$photoRE")
                                                      .existsSync(),
                                                  replacement: Text(
                                                      "File doesnt exist : ${directory
                                                          ?.path}/$photoRE"),
                                                  child: Image.file(
                                                    File(
                                                        "${directory
                                                            ?.path}/$photoRE"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Text(
                                                      "Left Eye (A.I.)",
                                                      style: TextStyle(
                                                          fontSize: 20),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 8.0),
                                                    child: Text(
                                                      leftresult,
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                        left: 8.0),
                                                    child: Text(
                                                      "KERATOPLASTY REQUIRED : $kerLE",
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )),
                                                Visibility(
                                                  visible: File(
                                                      "${directory
                                                          ?.path}/$photoLE")
                                                      .existsSync(),
                                                  replacement: Text(
                                                      "File doesnt exist : ${directory
                                                          ?.path}/$photoLE"),
                                                  child: Image.file(
                                                    File(
                                                        "${directory
                                                            ?.path}/$photoLE"),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text("Submit"),
                                        ),
                                      ]));
                            });

                        if (shouldPop != null && shouldPop) {
                          navKey.currentState?.popUntil(
                              ModalRoute.withName(
                                  '/${widget.survey.surveyID}'));
                        }
                      }
                      else {
                        navKey.currentState?.popUntil(
                            ModalRoute.withName('/${widget.survey.surveyID}'));
                      }
                    } on SocketException catch (e) {
                      if (e.osError?.errorCode == 7) {
                        navKey.currentState?.popUntil(
                            ModalRoute.withName('/${widget.survey.surveyID}'));
                      }
                      else {
                        navKey.currentState?.push(MaterialPageRoute(
                          settings: const RouteSettings(name: "/ErrorPage"),
                          builder: (context) =>
                              ErrorPage(errorMessage: e.toString()),
                        ),
                        );
                      }
                    }
                    on String catch (e) {
                      if(e == "TimeOut"){
                        navKey.currentState?.popUntil(
                            ModalRoute.withName('/${widget.survey.surveyID}'));

                      }
                      else{
                        navKey.currentState?.push(
                          MaterialPageRoute(
                            settings: const RouteSettings(name: "/ErrorPage"),
                            builder: (context) =>
                                ErrorPage(errorMessage: e.toString()),
                          ),
                        );
                      }

                    }
                    catch (e) {
                      navKey.currentState?.push(
                        MaterialPageRoute(
                          settings: const RouteSettings(name: "/ErrorPage"),
                          builder: (context) =>
                              ErrorPage(errorMessage: e.toString()),
                        ),
                      );
                    }

                  } else {
                    my_api.API.toFile
                        .updateAnswer(widget.hiveInterface, ans["answerID"]);
                    navKey.currentState?.popUntil(
                        ModalRoute.withName('/${widget.survey.surveyID}'));
                  }
                }
              }else if(widget.mode == SurveyPageMode.view){
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
