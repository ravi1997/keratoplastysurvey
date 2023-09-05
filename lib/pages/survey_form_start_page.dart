import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/survey_form_page.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/widget/logout_button.dart';

class SurveyFormStartPage extends StatefulWidget {
  const SurveyFormStartPage(
      {super.key,
      required this.hiveInterface,
      required this.survey,
      required this.mode});
  final my_api.HiveInterface hiveInterface;
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
    _data = MyData(
        hiveInterface: widget.hiveInterface,
        survey: widget.survey,
        mode: widget.mode);
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
                          hiveInterface: widget.hiveInterface,
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
      return PaginatedDataTable(
        source: _data,
        header: Text(header),
        columns: [
          const DataColumn(label: Text('ID')),
          const DataColumn(label: Text('Name')),
          const DataColumn(label: Text('Age/Gender')),
          if (widget.mode == SurveyPageMode.view)
            const DataColumn(label: Text('Action'))
        ],
        columnSpacing: 100,
        horizontalMargin: 10,
        rowsPerPage: 8,
        showCheckboxColumn: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.survey.surveyName),
        actions: [logoutButton(widget.hiveInterface)],
      ),
      body: createBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: (widget.mode == SurveyPageMode.view)
          ? FloatingActionButton.extended(
              onPressed: () async {
                (_data as MyData).upload();
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
  final my_api.HiveInterface hiveInterface;
  final Survey survey;
  late List<Map<dynamic, dynamic>> _data;
  final SurveyPageMode mode;

  MyData(
      {required this.hiveInterface, required this.survey, required this.mode}) {
    _data = my_api.API.getData(
        hiveInterface: hiveInterface, surveyId: survey.surveyID, mode: mode);
  }

  Future<void> upload() async {
    bool result = await my_api.API.uploadAnswers(datas: _data);
    if (result) {
      my_api.API.upload(hiveInterface: hiveInterface, datas: _data);
      _data.clear();
      notifyListeners();
    }
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => _data.length;
  @override
  int get selectedRowCount => 0;
  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]['ID'] ?? "")),
      DataCell(Text(_data[index]["name"] ?? "")),
      DataCell(Text('${_data[index]["age"]}/${_data[index]["gender"]}')),
      if (mode == SurveyPageMode.view)
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye),
              onPressed: () {
                ans = Map<String, dynamic>.from(_data[index]);
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
                ans = Map<String, dynamic>.from(_data[index]);
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
                my_api.API.deleteData(
                    hiveInterface: hiveInterface, peopleID: _data[index]['ID']);
                _data.remove(_data[index]);
                notifyListeners();
              },
            ),
          ],
        )),
    ]);
  }
}
