import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/camera_question_widget.dart';
import 'package:keratoplastysurvey/util.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

bool isEmpty(value) {
  return value == null || value == "";
}

Widget createQuestion(Question ques,
    {Function? callback, required SurveyPageMode mode,required Survey survey,required int currentSectionId}) {
  String required = (ques.required ?? false) ? '*' : '';
  String label = '${ques.question} $required';
  String hint = (ques.hint ?? "");
  String initvalue = "";
  print(ques.questionID);
  if ((ques.lastSaved ?? false || mode != SurveyPageMode.entry) &&
      ans['data'] != null) {
    var mylist = (ans['data'] as List);
    int index = mylist
        .indexWhere((element) => element['question_id'] == ques.questionID);
    if (index != -1) {
      initvalue = mylist[index]['value'].toString();
    }
  }

  if (ques.type == QuestionType.textfield) {
    var controller = TextEditingController(text: initvalue);
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return Visibility(
        visible: (ques.visibilityCondition != null)
            ? ques.visibilityCondition!.solve(ans)
            : true,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextFormField(
            enabled:
                mode == SurveyPageMode.entry || mode == SurveyPageMode.edit,
            decoration: InputDecoration(
              labelText: label,
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

                var mylist = (ans['data'] as List);
                int index = mylist.indexWhere(
                    (element) => element['question_id'] == ques.questionID);
                if (index == -1) {
                  mylist.add({
                    "value": value,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  });
                } else {
                  mylist[index] = {
                    "value": value,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  };
                }
                ans['data'] = mylist;

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
              var mylist = (ans['data'] as List);
              int index = mylist.indexWhere(
                  (element) => element['question_id'] == ques.questionID);
              if (index == -1) {
                mylist.add({
                  "value": value,
                  "question_id": ques.questionID,
                  "variable": ques.variable
                });
              } else {
                mylist[index] = {
                  "value": value,
                  "question_id": ques.questionID,
                  "variable": ques.variable
                };
              }
              ans['data'] = mylist;
              if (callback != null) {
                callback(() {});
              }
            },
            onChanged: (value) {
              if (ans['data'] == null) {
                ans['data'] = [];
              }

              var mylist = (ans['data'] as List);
              int index = mylist.indexWhere(
                  (element) => element['question_id'] == ques.questionID);
              if (index == -1) {
                mylist.add({
                  "value": value,
                  "question_id": ques.questionID,
                  "variable": ques.variable
                });
              } else {
                mylist[index] = {
                  "value": value,
                  "question_id": ques.questionID,
                  "variable": ques.variable
                };
              }
              ans['data'] = mylist;
              if (callback != null) {
                callback(() {});
              }
            },
            initialValue: ques.defaultValue,
          ),
        ));
  } else if (ques.type == QuestionType.dropdown) {
    print(ques.question);
    return Visibility(
        visible: (ques.visibilityCondition != null)
            ? ques.visibilityCondition!.solve(ans)
            : true,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: DropdownButtonFormField<int>(
		 isExpanded: true,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              value: ((ques.lastSaved ?? false) && initvalue != "")
                  ? int.parse(initvalue)
                  : (ques.defaultValue != null)
                      ? ques.valueRange.indexOf(ques.defaultValue!)
                      : null,
              items: ques.valueRange.map((option) {
                return DropdownMenuItem<int>(
                  value: ques.valueRange.indexOf(option) + 1,
                  child: Text(option),
		overflow: TextOverflow.ellipsis
                );
              }).toList(),
              onChanged:
                  (mode == SurveyPageMode.entry || mode == SurveyPageMode.edit)
                      ? (value) {
                          if (ans['data'] == null) {
                            ans['data'] = [];
                          }
                          var mylist = (ans['data'] as List);
                          int index = mylist.indexWhere((element) =>
                              element['question_id'] == ques.questionID);
                          if (index == -1) {
                            mylist.add({
                              "value": value,
                              "question_id": ques.questionID,
                              "variable": ques.variable
                            });
                          } else {
                            mylist[index] = {
                              "value": value,
                              "question_id": ques.questionID,
                              "variable": ques.variable
                            };
                          }
                          ans['data'] = mylist;
                          if (callback != null) {
                            callback(() {});
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
                  var mylist = (ans['data'] as List);
                  int index = mylist.indexWhere(
                      (element) => element['question_id'] == ques.questionID);
                  if (index == -1) {
                    mylist.add({
                      "value": value,
                      "question_id": ques.questionID,
                      "variable": ques.variable
                    });
                  } else {
                    mylist[index] = {
                      "value": value,
                      "question_id": ques.questionID,
                      "variable": ques.variable
                    };
                  }
                  ans['data'] = mylist;

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
                var mylist = (ans['data'] as List);
                int index = mylist.indexWhere(
                    (element) => element['question_id'] == ques.questionID);
                if (index == -1) {
                  mylist.add({
                    "value": value,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  });
                } else {
                  mylist[index] = {
                    "value": value,
                    "question_id": ques.questionID,
                    "variable": ques.variable
                  };
                }
                ans['data'] = mylist;
                if (callback != null) {
                  callback(() {});
                }
              },
            )));
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
          var mylist = (ans['data'] as List);
          int index = mylist.indexWhere(
              (element) => element['question_id'] == ques.questionID);
          if (index == -1) {
            mylist.add({
              "value": value,
              "question_id": ques.questionID,
              "variable": ques.variable
            });
          } else {
            mylist[index] = {
              "value": value,
              "question_id": ques.questionID,
              "variable": ques.variable
            };
          }
          ans['data'] = mylist;
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
        // locale: const Locale.fromSubtags(languageCode: 'fr'),
      ),
    );
  } else if (ques.type == QuestionType.imagePicker) {

    final surveyId = survey.surveyID ??"";

    return Visibility(
        visible: (ques.visibilityCondition != null)
            ? ques.visibilityCondition!.solve(ans)
            : true,
        child: Container(
          child: Row(
            children: [
              Text(ques.question),
              ElevatedButton(
                  onPressed: () {
                    navKey.currentState?.push(
                      MaterialPageRoute(
                          settings: const RouteSettings(name: "/camera/camera"),
                          builder: (context) => CameraQuestionWidget(
                              question: ques,
                              surveyId: surveyId ,
                              getBack: "/$surveyId/$currentSectionId")),
                    );
                  },
                  child: const Text("Upload"))
            ],
          ),
        ));
  }
  return Container();
}
