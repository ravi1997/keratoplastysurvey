import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/hive_interface.dart'
    as my_hive_interface;
import 'package:keratoplastysurvey/controller/util.dart';

class ToHive {
  Future<void> storeAnswer(
      my_hive_interface.HiveInterface hiveInterface) async {
    final answersBox = hiveInterface.getBoxbyName('answers');
    answersBox?.add(Util.anstoFlat());
  }

  Future<void> storeUser(my_hive_interface.HiveInterface hiveInterface) async {
    final userBox = hiveInterface.getBoxbyName('user');
    while (userBox!.length > 0) {
      userBox.deleteAt(0);
    }
    await userBox.add(user.toJson());
  }

  void storeSurvey(my_hive_interface.HiveInterface hiveInterface,
      Map<String, dynamic> survey) async {
    final surveyBox = hiveInterface.getBoxbyName('survey');
    await surveyBox?.add(survey);
  }

  void deleteAnswer(
      my_hive_interface.HiveInterface hiveInterface, String peopleID) {
    final answersBox = hiveInterface.getBoxbyName('answers');
    int index = -1;
    for (int i = 0; i < answersBox!.length; i++) {
      var myanswer = answersBox.getAt(i);
      if (myanswer['ID'] == peopleID) {
        index = i;
      }
    }

    if (index == -1) {
      return;
    }

    var myans = answersBox.getAt(index);
    myans['STATUS'] = 'DELETED';
    answersBox.putAt(index, myans);
  }

  void uploadAnswer(my_hive_interface.HiveInterface hiveInterface,
      List<Map<dynamic, dynamic>> datas) {
    final answersBox = hiveInterface.getBoxbyName('answers');
    for (var data in datas) {
      int index = -1;
      for (int i = 0; i < answersBox!.length; i++) {
        var myanswer = answersBox.getAt(i);
        if (myanswer['ID'] == data['ID']) {
          index = i;
        }
      }

      if (index == -1) {
        return;
      }

      var myans = answersBox.getAt(index);
      myans['STATUS'] = 'UPLOADED';
      answersBox.putAt(index, myans);
    }
  }
}
