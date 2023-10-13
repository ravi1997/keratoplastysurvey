import 'dart:convert';

import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/local_store_interface.dart'
    as my_file_interface;
import 'package:keratoplastysurvey/model.dart';

class ToFile {
  void storeAnswer(
      my_file_interface.LocalStoreInterface fileInterface) {
    final answersBox = fileInterface.getBoxbyName('answers');
    var data = fileInterface.readAndDecryptFile(answersBox);
    if(data == ""){
      data = "[]";
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));
    fileData.add(ans);

    fileInterface.writeAndEncryptFile(answersBox, json.encode(fileData));
  }

  void storeAIResult(
      my_file_interface.LocalStoreInterface fileInterface,KeratoplastyAIResult result) async {
    final answersBox = fileInterface.getBoxbyName('aiResult');
    var data = fileInterface.readAndDecryptFile(answersBox);
    if(data == ""){
      data = "[]";
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));
    fileData.add(result.toJson());

    fileInterface.writeAndEncryptFile(answersBox, json.encode(fileData));
  }


  void storeUser(my_file_interface.LocalStoreInterface fileInterface) {
    final userBox = fileInterface.getBoxbyName('user');
    fileInterface.writeAndEncryptFile(userBox, json.encode(user.toJson()));
  }

  void storeSurvey(my_file_interface.LocalStoreInterface fileInterface,
      Map<String, dynamic> survey) {
    final surveyBox = fileInterface.getBoxbyName('survey');
    fileInterface.writeAndEncryptFile(surveyBox, json.encode(survey));
  }

  void deleteAnswer(
      my_file_interface.LocalStoreInterface fileInterface, String peopleID) {
    final answersBox = fileInterface.getBoxbyName('answers');
    final data = fileInterface.readAndDecryptFile(answersBox);
    if(data == ""){
      return;
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));

    int index = -1;
    for (int i = 0; i < fileData.length; i++) {
      var myAnswer = fileData[i];
      if (myAnswer['answerID'] == peopleID) {
        index = i;
      }
    }

    if (index == -1) {
      return;
    }

    fileData[index]['STATUS'] = 'DELETED';
    fileInterface.writeAndEncryptFile(answersBox, json.encode(fileData));

  }

  void updateAnswer(
      my_file_interface.LocalStoreInterface fileInterface, String peopleID) {
    final answersBox = fileInterface.getBoxbyName('answers');
    final data = fileInterface.readAndDecryptFile(answersBox);
    if(data == ""){
      return;
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));
    int index = -1;
    for (int i = 0; i < fileData.length; i++) {
      var myAnswer = fileData[i];
      if (myAnswer['answerID'] == peopleID) {
        index = i;
      }
    }

    if (index == -1) {
      return;
    }
    fileData[index] = ans;
    fileInterface.writeAndEncryptFile(answersBox, json.encode(fileData));

  }
  void updateAIResult(
      my_file_interface.LocalStoreInterface fileInterface, KeratoplastyAIResult result) {
    final answersBox = fileInterface.getBoxbyName('aiResult');
    final data = fileInterface.readAndDecryptFile(answersBox);
    if(data == ""){
      return;
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));
    int index = -1;
    for (int i = 0; i < fileData.length; i++) {
      var myAnswer = fileData[i];
      if (myAnswer['answerID'] == result.answerID) {
        index = i;
      }
    }

    if (index == -1) {
      return;
    }
    fileData[index] = ans;
    fileInterface.writeAndEncryptFile(answersBox, json.encode(fileData));

  }

  void uploadAnswer(my_file_interface.LocalStoreInterface fileInterface,
      List<Map<dynamic, dynamic>> datas)  {
    final answersBox = fileInterface.getBoxbyName('answers');
    final data = fileInterface.readAndDecryptFile(answersBox);
    if(data == ""){
      return;
    }
    List<Map<String, dynamic>> fileData = List<Map<String, dynamic>>.from(json.decode(data));
    for (var data in datas) {
      int index = -1;
      for (int i = 0; i < fileData.length; i++) {
        var myAnswer = fileData[i];
        if (myAnswer['answerID'] == data['answerID']) {
          index = i;
        }
      }

      if (index == -1) {
        continue;
      }

      fileData[index]['STATUS'] = 'UPLOADED';
    }

    fileInterface.writeAndEncryptFile(answersBox, json.encode(fileData));
  }
}
