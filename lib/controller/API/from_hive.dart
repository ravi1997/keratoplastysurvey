import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/hive_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/model.dart';

class FromHive {
  Future<void> loadUser(my_hive_interface.HiveInterface hiveInterface) async {
    final userBox = hiveInterface.getBoxbyName('user');
    user = User.fromJson(Map<String, dynamic>.from(userBox!.getAt(0) as Map));
  }

  List<Map<dynamic, dynamic>> loadAnswers(
      my_hive_interface.HiveInterface hiveInterface,
      String surveyId,
      SurveyPageMode mode) {
    final answersBox = hiveInterface.getBoxbyName('answers');

    List<Map<dynamic, dynamic>> answers = [];
    for (int i = 0; i < answersBox!.length; i++) {
      if (answersBox.getAt(i)['SURVEY-ID'] == surveyId) {
        if ((mode == SurveyPageMode.view &&
                answersBox.getAt(i)['STATUS'] == 'CREATED') ||
            (mode == SurveyPageMode.upload &&
                answersBox.getAt(i)['STATUS'] == 'UPLOADED') ||
            (mode == SurveyPageMode.delete &&
                answersBox.getAt(i)['STATUS'] == 'DELETED')) {
          answers.add(answersBox.getAt(i));
        }
      }
    }
    return answers;
  }

  List<Survey> loadSurveys(my_hive_interface.HiveInterface hiveInterface) {
    final surveyBox = hiveInterface.getBoxbyName('survey');
    List<Survey> result = [];
    for (int i = 0; i < surveyBox!.length; i++) {
      result.add(Survey.fromJson(
          Map<String, dynamic>.from(surveyBox.getAt(i) as Map)));
    }
    return result;
  }
}
