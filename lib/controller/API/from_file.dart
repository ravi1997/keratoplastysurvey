import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/local_store_interface.dart'
    as my_file_interface;
import 'package:keratoplastysurvey/model.dart';
import 'dart:convert';

class FromFile {
  void loadUser(my_file_interface.LocalStoreInterface fileInterface) {
    final userBox = fileInterface.getBoxbyName('user');
    final data = fileInterface.readAndDecryptFile(userBox);
    user = User.fromJson(json.decode(data));
  }

  List<Map<String, dynamic>> loadAnswers(
      my_file_interface.LocalStoreInterface fileInterface,
      String surveyId,
      SurveyPageMode mode)  {
    final answersBox = fileInterface.getBoxbyName('answers');
    final data = fileInterface.readAndDecryptFile(answersBox);
    if(data==""){
      return [];
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));


    List<Map<String, dynamic>> answers = [];
    for (int i = 0; i < fileData.length; i++) {
      if (fileData[i]['SURVEY-ID'] == surveyId) {
        if ((mode == SurveyPageMode.view &&
            fileData[i]['STATUS'] == 'CREATED') ||
            (mode == SurveyPageMode.upload &&
                fileData[i]['STATUS'] == 'UPLOADED') ||
            (mode == SurveyPageMode.delete &&
                fileData[i]['STATUS'] == 'DELETED')) {
          answers.add(fileData[i]);
        }else{
        }

      }
      else{

      }
    }
    return answers;
  }

  List<Survey> loadSurveys(my_file_interface.LocalStoreInterface fileInterface) {
    final surveyBox = fileInterface.getBoxbyName('survey');
    final data = fileInterface.readAndDecryptFile(surveyBox);
    if(data == ""){
      return [];
    }
    print(data);
    dynamic jsonData = json.decode(data);

    List<Map<String, dynamic>> fileData;

    if (jsonData is List) {
      fileData = jsonData.cast<Map<String, dynamic>>();
      List<Survey> result = [];
      for (int i = 0; i < fileData.length; i++) {
        var data = fileData[i];
        result.add(Survey.fromJson(data));
      }
      return result;

    }
    else{
      return [];
    }

  }
  List<KeratoplastyAIResult> loadAIResults(my_file_interface.LocalStoreInterface fileInterface) {
    final surveyBox = fileInterface.getBoxbyName('aiResult');
    final data = fileInterface.readAndDecryptFile(surveyBox);
    if(data == ""){
      return [];
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));
    List<KeratoplastyAIResult> result = [];
    for (int i = 0; i < fileData.length; i++) {
      result.add(KeratoplastyAIResult.fromJson(
          Map<String, dynamic>.from(fileData[i])));
    }
    print("file data length : ${fileData.length}");
    print("result data length : ${result.length}");
    return result;
  }

}
