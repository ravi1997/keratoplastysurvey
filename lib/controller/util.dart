import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Util {
  static Future<String> getProjectName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String projectName = packageInfo.appName;
    return projectName;
  }

  static Map<String, dynamic> anstoFlat() {
    Map<String, dynamic> result = {};

    try{
      for (var value in ans['data']) {
        if(value["QUESTION_TYPE"]==QuestionType.dropdown.toString()){
          result[value['variable']] = value["VALUE_RANGE"][int.parse(value["value"].toString())-1];
        }
        else{
          result[value['variable']] = value["value"];
        }
      }

      result['recorderID'] = ans['recorderID'];
      result["createAt"] = ans['CREATE-DATE-TIME'];

      result["answerID"] = ans['answerID'];
      result["recorder"] = "1111";

    }
    catch(e){
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Future.delayed(Duration(seconds: 2));
    }
    return result;
  }
}
