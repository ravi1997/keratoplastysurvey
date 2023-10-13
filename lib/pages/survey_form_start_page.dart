import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/local_store_interface.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/survey_form_page.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/widget/logout_button.dart';

import 'error_page.dart';

class SurveyFormStartPage extends StatefulWidget {
  const SurveyFormStartPage(
      {super.key,
      required this.fileInterface,
      required this.survey,
      required this.mode});
  final LocalStoreInterface fileInterface;
  final SurveyPageMode mode;

  final Survey survey;

  @override
  State<SurveyFormStartPage> createState() => _SurveyFormStartPageState();
}

class _SurveyFormStartPageState extends State<SurveyFormStartPage> {
  late DataTableSource _data;

  @override
  void initState() {
    super.initState();
  }

  Widget createBody() {
    if (widget.mode == SurveyPageMode.entry) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Expanded(
              child: Text(
            widget.survey.description,
            textAlign: TextAlign.justify,
            overflow: TextOverflow.ellipsis,
            maxLines: 15,
          )),
          ElevatedButton(
              onPressed: () {
                navKey.currentState?.push(
                  MaterialPageRoute(
                      settings: RouteSettings(
                          name:
                              "/${widget.survey.surveyID}/${widget.survey.sections[1].sectionID}"),
                      builder: (context) => SurveyFormPage(
                          hiveInterface: widget.fileInterface,
                          survey: widget.survey,
                          mode: widget.mode)),
                );
              },
              child: const Text('Start'))
        ]),
      );
    } else {
      String header = "";
      if (widget.mode == SurveyPageMode.view) {
        header = "CREATED ENTRIES";
      } else if (widget.mode == SurveyPageMode.upload) {
        header = "UPLOADED ENTRIES";
      } else if (widget.mode == SurveyPageMode.delete) {
        header = "DELETED ENTRIES";
      }

      _data =MyData(hiveInterface: widget.fileInterface, survey: widget.survey, mode: widget.mode, data: my_api.API.fromFile.loadAnswers(widget.fileInterface, widget.survey.surveyID ?? "",widget.mode));
      return SingleChildScrollView(
        child: PaginatedDataTable(
          source: _data,
          header: Text(header),
          columns: [
            const DataColumn(label: Text('ID')),
            const DataColumn(label: Text('Name')),
            const DataColumn(label: Text('Age/Gender')),
            const DataColumn(label: Text('CORNEAL OPACITY RE')),
            const DataColumn(label: Text('AI Result RE')),
            const DataColumn(label: Text('KERATOPLASTY  RE')),
            const DataColumn(label: Text('CORNEAL OPACITY LE')),
            const DataColumn(label: Text('AI Result LE')),
            const DataColumn(label: Text('KERATOPLASTY  LE')),
            if (widget.mode == SurveyPageMode.view)
              const DataColumn(label: Text('Action'))
          ],
          columnSpacing: 100,
          horizontalMargin: 10,
          rowsPerPage: 8,
          showCheckboxColumn: false,
        ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey.surveyName),
        actions: [logoutButton(widget.fileInterface)],
      ),
      body: createBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (widget.mode == SurveyPageMode.view)
          ? FloatingActionButton.extended(
              onPressed: () async {
                (_data as MyData).upload();
                setState((){});
              },
              label: const Text('Upload'),
              icon: const Icon(Icons.upload),
              backgroundColor: Colors.green,
            )
          : null,
    );
  }
}

class MyData extends DataTableSource {
  // Generate some made-up data
  final LocalStoreInterface hiveInterface;
  final Survey survey;
  List<Map<String, dynamic>> data;
  final SurveyPageMode mode;

  MyData(
      {required this.hiveInterface, required this.survey, required this.mode,required this.data}) ;

  Future<void> upload() async {

    try {
      final scriptMessages =
      await my_api.API.answerapi.uploadAnswer(data);

      if (scriptMessages != null){
        for(int i =0;i<scriptMessages.length;i++){
          var scriptMessage = scriptMessages[i];
          ans = data[i];
          var plist = (ans['data'] as List);
          int index = plist.indexWhere(
                  (element) =>
              element['variable'] == "examination");
          if (plist[index]["value"] == 1) {
            final leftresult = scriptMessage['left']['type'];
            final rightresult = scriptMessage['right']['type'];
            final rightconfidence = scriptMessage['right']['type'];
            final leftconfidence = scriptMessage['left']['type'];
            var airesult = KeratoplastyAIResult(
                answerID: ans["answerID"],
                resultLE: leftresult,
                resultRE: rightresult,
                resultLEConfidence: leftconfidence,
                resultREConfidence: rightconfidence);

            my_api.API.toFile.storeAIResult(
                hiveInterface, airesult);

          }
        }
      }
      my_api.API.toFile.uploadAnswer(hiveInterface, data);

      data.clear();
      notifyListeners();
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


  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    Map<String, dynamic> result = {};

    try {
      for (var value in data[index]['data']) {
        if (value["QUESTION_TYPE"] == QuestionType.dropdown.toString()) {
          result[value['variable']] =
              value["VALUE_RANGE"][int.parse(value["value"].toString()) - 1];
        } else {
          result[value['variable']] = value["value"];
        }
      }
    } catch (e){
      // nothing
    }
    String kerRE = "No", kerLE = "No";

    if (result['coRE'] == "Present" &&
        result['sizeRE'] ==
            ">5 mm (equal to or more than 2 times the pupil size)" &&
        result['cpRE'] == "Central (covering atleast half the pupil)" &&
        result['pinRE'] != "6/6" &&
        result['pinRE'] != "6/7.5" &&
        result['pinRE'] != "6/9.5" &&
        result['pinRE'] != "6/12" &&
        result['pinRE'] != "No light perception (PL-)") {
      kerRE = "Yes";
    }
    if (result['coLE'] == "Present" &&
        result['sizeLE'] ==
            ">5 mm (equal to or more than 2 times the pupil size)" &&
        result['cpLE'] == "Central (covering atleast half the pupil)" &&
        result['pinLE'] != "6/6" &&
        result['pinLE'] != "6/7.5" &&
        result['pinLE'] != "6/9.5" &&
        result['pinLE'] != "6/12" &&
        result['pinLE'] != "No light perception (PL-)") {
      kerLE = "Yes";
    }

    List<KeratoplastyAIResult> results =  my_api.API.fromFile.loadAIResults(hiveInterface);

    print("from start page, result length : ${results.length}");
    var myIndex = results
        .indexWhere((element) => element.answerID == data[index]['answerID']);
    print("Checking value for ${data[index]['answerID']}");
    print("My index is $myIndex");

    return DataRow(cells: [
      DataCell(Text(data[index]['answerID'] ?? "")),
      DataCell(Text(result["name"] ?? "")),
      DataCell(Text('${result["age"]}/${result["gender"]}')),
      DataCell(Text('${result["coRE"] ?? "N/A"}')),
      DataCell(Text((myIndex != -1) ? results[myIndex].resultRE : "N/A")),
      DataCell(Text(kerRE)),
      DataCell(Text('${result["coLE"] ?? "N/A"}')),
      DataCell(Text((myIndex != -1) ? results[myIndex].resultLE : "N/A")),
      DataCell(Text(kerLE)),
      if (mode == SurveyPageMode.view)
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: () {
                ans = Map<String, dynamic>.from(data[index]);
                navKey.currentState?.push(
                  MaterialPageRoute(
                      settings: RouteSettings(name: "/${survey.surveyID}/1"),
                      builder: (context) => SurveyFormPage(
                          hiveInterface: hiveInterface,
                          survey: survey,
                          mode: SurveyPageMode.view)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                ans = Map<String, dynamic>.from(data[index]);
                navKey.currentState?.push(
                  MaterialPageRoute(
                      settings: RouteSettings(name: "/${survey.surveyID}/1"),
                      builder: (context) => SurveyFormPage(
                          hiveInterface: hiveInterface,
                          survey: survey,
                          mode: SurveyPageMode.edit)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                my_api.API.toFile
                    .deleteAnswer(hiveInterface, data[index]['answerID']);
                data.remove(data[index]);
                notifyListeners();
              },
            ),
          ],
        )),
    ]);
  }
}
