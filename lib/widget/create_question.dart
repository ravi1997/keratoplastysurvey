import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/camera_question_widget.dart';
import 'package:keratoplastysurvey/util.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

bool isEmpty(value) {
  return value == null || value == "";
}

Widget createQuestion(Question ques,
    {Function? callback,
    required SurveyPageMode mode,
    required Survey survey,
    required int currentSectionId,
    required BuildContext context}) {
  String required = (ques.required ?? false) ? '*' : '';
  String label = '${ques.question} $required';
  String hint = (ques.hint ?? "");
  String initValue = "";
  if ((ques.lastSaved ?? false || mode != SurveyPageMode.entry) &&
      ans['data'] != null) {
    var plist = (ans['data'] as List);
    int index = plist
        .indexWhere((element) => element['question_id'] == ques.questionID);
    if (index != -1) {
      initValue = plist[index]['value'].toString();
    }
  }

  if (ques.type == QuestionType.textfield) {
    var controller = TextEditingController(text: initValue);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return Visibility(
        visible: (ques.visibilityCondition != null)
            ? ques.visibilityCondition!.solve(ans)
            : true,
        child: Column(children: [
          Row(children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  label,
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              enabled:
                  mode == SurveyPageMode.entry || mode == SurveyPageMode.edit,
              decoration: InputDecoration(
                labelText: hint,
                hintText: hint,
                border: const OutlineInputBorder(),
              ),
              autofocus: false,
              controller: controller,
              validator: (value) {
                if (((ques.visibilityCondition != null) &&
                        ques.visibilityCondition!.solve(ans)) ||
                    (ques.visibilityCondition == null)) {
                  if ((ques.required ?? false) && isEmpty(value)) {
                    return 'Please enter the value';
                  }

                  if (ans['data'] == null) {
                    ans['data'] = [];
                  }

                  var plist = (ans['data'] as List);
                  int index = plist.indexWhere(
                      (element) => element['question_id'] == ques.questionID);
                  if (index == -1) {
                    plist.add({
                      "value": value,
                      "QUESTION_TYPE": ques.type.toString(),
                      "VALUE_RANGE": ques.valueRange,
                      "question_id": ques.questionID,
                      "variable": ques.variable
                    });
                  } else {
                    plist[index] = {
                      "value": value,
                      "QUESTION_TYPE": ques.type.toString(),
                      "VALUE_RANGE": ques.valueRange,
                      "question_id": ques.questionID,
                      "variable": ques.variable
                    };
                  }
                  ans['data'] = plist;

                  if (ques.constraint != null) {
                    Condition condition = ques.constraint!;

                    if (condition.regex != null && condition.regex != "") {
                      if (condition.solveRegex(value!)) {
                        return ques.constraintMessage;
                      }
                    } else if (!condition.solve(ans)) {
                      return ques.constraintMessage;
                    }
                  }
                }
                return null;
              },
              onSaved: (value) {
                if (ans['data'] == null) {
                  ans['data'] = [];
                }
                var plist = (ans['data'] as List);
                int index = plist.indexWhere(
                    (element) => element['question_id'] == ques.questionID);
                if (index == -1) {
                  plist.add({
                    "value": value,
                    "QUESTION_TYPE": ques.type.toString(),
                    "VALUE_RANGE": ques.valueRange,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  });
                } else {
                  plist[index] = {
                    "value": value,
                    "QUESTION_TYPE": ques.type.toString(),
                    "VALUE_RANGE": ques.valueRange,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  };
                }
                ans['data'] = plist;
                if (callback != null) {
                  callback(() {});
                }
              },
              onChanged: (value) {
                if (ans['data'] == null) {
                  ans['data'] = [];
                }

                var plist = (ans['data'] as List);
                int index = plist.indexWhere(
                    (element) => element['question_id'] == ques.questionID);
                if (index == -1) {
                  plist.add({
                    "value": value,
                    "QUESTION_TYPE": ques.type.toString(),
                    "VALUE_RANGE": ques.valueRange,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  });
                } else {
                  plist[index] = {
                    "value": value,
                    "QUESTION_TYPE": ques.type.toString(),
                    "VALUE_RANGE": ques.valueRange,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  };
                }
                ans['data'] = plist;
                if (callback != null) {
                  callback(() {});
                }
              },
              initialValue: ques.defaultValue,
            ),
          )
        ]));
  } else if (ques.type == QuestionType.dropdown) {
    return Visibility(
        visible: (ques.visibilityCondition != null)
            ? ques.visibilityCondition!.solve(ans)
            : true,
        child: Column(
          children: [
            Row(children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    label,
                  ),
                ),
              ),
            ]),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: "Select",
                    border: OutlineInputBorder(),
                  ),
                  value: ((ques.lastSaved ?? false) && initValue != "")
                      ? int.parse(initValue)
                      : (ques.defaultValue != null)
                          ? ques.valueRange.indexOf(ques.defaultValue!)
                          : null,
                  items: ques.valueRange.map((option) {
                    return DropdownMenuItem<int>(
                      value: ques.valueRange.indexOf(option) + 1,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (mode == SurveyPageMode.entry ||
                          mode == SurveyPageMode.edit)
                      ? (value) {
                          if (value != null) {
                            if (ans['data'] == null) {
                              ans['data'] = [];
                            }
                            var plist = (ans['data'] as List);
                            int index = plist.indexWhere((element) =>
                                element['question_id'] == ques.questionID);
                            if (index == -1) {
                              plist.add({
                                "value": value,
                                "QUESTION_TYPE": ques.type.toString(),
                                "VALUE_RANGE": ques.valueRange,
                                "question_id": ques.questionID,
                                "variable": ques.variable
                              });
                            } else {
                              plist[index] = {
                                "value": value,
                                "QUESTION_TYPE": ques.type.toString(),
                                "VALUE_RANGE": ques.valueRange,
                                "question_id": ques.questionID,
                                "variable": ques.variable
                              };
                            }
                            ans['data'] = plist;
                            if (callback != null) {
                              callback(() {});
                            }
                          }
                        }
                      : null,
                  validator: (value) {
                    if (((ques.visibilityCondition != null) &&
                            ques.visibilityCondition!.solve(ans)) ||
                        (ques.visibilityCondition == null)) {
                      if ((ques.required ?? false) && isEmpty(value)) {
                        return 'Please enter the value';
                      }
                      if (ans['data'] == null) {
                        ans['data'] = [];
                      }
                      var plist = (ans['data'] as List);
                      int index = plist.indexWhere((element) =>
                          element['question_id'] == ques.questionID);
                      if (index == -1) {
                        plist.add({
                          "value": value,
                          "QUESTION_TYPE": ques.type.toString(),
                          "VALUE_RANGE": ques.valueRange,
                          "question_id": ques.questionID,
                          "variable": ques.variable
                        });
                      } else {
                        plist[index] = {
                          "value": value,
                          "QUESTION_TYPE": ques.type.toString(),
                          "VALUE_RANGE": ques.valueRange,
                          "question_id": ques.questionID,
                          "variable": ques.variable
                        };
                      }
                      ans['data'] = plist;

                      if (ques.constraint != null) {
                        Condition condition = ques.constraint!;

                        if (!condition.solve(ans)) {
                          return ques.constraintMessage;
                        }
                      }
                    }
                    return null;
                  },
                  onSaved: (value) {
                    if (ans['data'] == null) {
                      ans['data'] = [];
                    }
                    var plist = (ans['data'] as List);
                    int index = plist.indexWhere(
                        (element) => element['question_id'] == ques.questionID);
                    if (index == -1) {
                      plist.add({
                        "value": value,
                        "QUESTION_TYPE": ques.type.toString(),
                        "VALUE_RANGE": ques.valueRange,
                        "question_id": ques.questionID,
                        "variable": ques.variable
                      });
                    } else {
                      plist[index] = {
                        "value": value,
                        "QUESTION_TYPE": ques.type.toString(),
                        "VALUE_RANGE": ques.valueRange,
                        "question_id": ques.questionID,
                        "variable": ques.variable
                      };
                    }
                    ans['data'] = plist;
                    if (callback != null) {
                      callback(() {});
                    }
                  },
                ))
          ],
        ));
  } else if (ques.type == QuestionType.radiobutton) {
    return Visibility(
      visible: (ques.visibilityCondition != null)
          ? ques.visibilityCondition!.solve(ans)
          : true,
      child: FormBuilderRadioGroup<String>(
        decoration: InputDecoration(
          labelText: ques.question,
        ),
        initialValue: null,
        name: ques.variable,
        onChanged: (value) {
          var plist = (ans['data'] as List);
          int index = plist.indexWhere(
              (element) => element['question_id'] == ques.questionID);
          if (index == -1) {
            plist.add({
              "value": value,
              "QUESTION_TYPE": ques.type.toString(),
              "VALUE_RANGE": ques.valueRange,
              "question_id": ques.questionID,
              "variable": ques.variable
            });
          } else {
            plist[index] = {
              "value": value,
              "QUESTION_TYPE": ques.type.toString(),
              "VALUE_RANGE": ques.valueRange,
              "question_id": ques.questionID,
              "variable": ques.variable
            };
          }
          ans['data'] = plist;
        },
        validator: (value) {
          if (((ques.visibilityCondition != null) &&
                  ques.visibilityCondition!.solve(ans)) ||
              (ques.visibilityCondition == null)) {
            if ((ques.required ?? false) && isEmpty(value)) {
              return 'Please enter the value';
            }
          }
          return null;
        },
        options: ques.valueRange
            .map((lang) => FormBuilderFieldOption(
                  value: lang,
                  child: Text(lang),
                ))
            .toList(),
        controlAffinity: ControlAffinity.trailing,
      ),
    );
  } else if (ques.type == QuestionType.datePicker) {
    return Visibility(
      visible: (ques.visibilityCondition != null)
          ? ques.visibilityCondition!.solve(ans)
          : true,
      child: FormBuilderDateTimePicker(
        validator: (value) {
          if (((ques.visibilityCondition != null) &&
                  ques.visibilityCondition!.solve(ans)) ||
              (ques.visibilityCondition == null)) {
            if ((ques.required ?? false) && isEmpty(value)) {
              return 'Please enter the value';
            }
          }
          return null;
        },
        name: 'date',
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialValue: DateTime.now(),
        inputType: InputType.both,
        decoration: InputDecoration(
          labelText: ques.question,
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {},
          ),
        ),
        initialTime: const TimeOfDay(hour: 8, minute: 0),
      ),
    );
  } else if (ques.type == QuestionType.imagePicker) {
    final surveyId = survey.surveyID ?? "";
    return Visibility(
        visible: (ques.visibilityCondition != null)
            ? ques.visibilityCondition!.solve(ans)
            : true,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(ques.question),
                ],
              ),
              if (mode != SurveyPageMode.view)
                Column(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          navKey.currentState?.push(
                            MaterialPageRoute(
                                settings:
                                    const RouteSettings(name: "/camera/camera"),
                                builder: (context) => CameraQuestionWidget(
                                    question: ques,
                                    surveyId: surveyId,
                                    getBack: "/$surveyId/$currentSectionId")),
                          );
                          callback!(() {});
                        },
                        child: const Text("Upload")),
                  ],
                ),
              Visibility(
                visible: ans['data'].indexWhere((element) =>
                        element['question_id'] == ques.questionID) !=
                    -1,
                child: Column(
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          var path = "/assets/db";
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

                          directory =
                              Directory("${directory.path}/$projectName");

                          var plist = (ans['data'] as List);
                          int index = plist.indexWhere((element) =>
                              element['question_id'] == ques.questionID);
                          path = "${directory.path}/${plist[index]["value"]}";
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'PICTURE',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
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
                                      Visibility(
                                        visible: File(path).existsSync(),
                                        replacement:
                                            Text("File doesnt exist : $path"),
                                        child: Image.file(
                                          File(path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ]));
                              });
                        },
                        child: const Text("View"))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
  return Container();
}
