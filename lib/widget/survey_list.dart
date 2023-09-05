import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/pages/survey_form_start_page.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;

class SurveyList extends StatefulWidget {
  const SurveyList(
      {super.key, required this.hiveInterface, required this.mode});
  final my_api.HiveInterface hiveInterface;
  final SurveyPageMode mode;

  @override
  State<SurveyList> createState() => _SurveyListState();
}

class _SurveyListState extends State<SurveyList> {
  List<ElevatedButton> buttons = [];
  late DataTableSource _data;

  @override
  void initState() {
    super.initState();
    if (widget.mode == SurveyPageMode.admin) {
      _data = SurveyPageDataSource();
    }
    for (var survey in surveys) {
      buttons.add(ElevatedButton(
          onPressed: () {
            navKey.currentState?.push(
              MaterialPageRoute(
                  settings: RouteSettings(name: "/${survey.surveyID}"),
                  builder: (context) => SurveyFormStartPage(
                      survey: survey,
                      hiveInterface: widget.hiveInterface,
                      mode: widget.mode)),
            );
          },
          child: Text(survey.surveyName)));
    }
    ans.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: buttons,
    );
  }
}

class SurveyPageDataSource extends DataTableSource {
  // Generate some made-up data
  late List<Survey> _data;

  SurveyPageDataSource() {
    _data = surveys;
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
      DataCell(Text(_data[index].surveyName)),
      DataCell(Text(_data[index].activeFrom.toIso8601String())),
      DataCell(Text(_data[index].activeTill.toIso8601String())),
      DataCell(Row(
        children: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              /* navKey.currentState?.push(
                MaterialPageRoute(
                    settings:
                        RouteSettings(name: "/${_data[index].surveyID}/admin"),
                    builder: (context) => SurveyFormPage(
                        hiveInterface: hiveInterface,
                        survey: survey,
                        mode: SurveyPageMode.edit)),
              ); */
            },
          ),
        ],
      ))
    ]);
  }
}
