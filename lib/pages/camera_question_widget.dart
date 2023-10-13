import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:keratoplastysurvey/widget/camera_widget.dart';
import 'package:path_provider/path_provider.dart';

class CameraQuestionWidget extends StatefulWidget {
  const CameraQuestionWidget(
      {super.key,
      required this.question,
      required this.surveyId,
      required this.getBack});

  final String getBack;
  final Question question;
  final String surveyId;

  @override
  State<CameraQuestionWidget> createState() => _CameraQuestionWidgetState();
}

class _CameraQuestionWidgetState extends State<CameraQuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question.question),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(
                    source: ImageSource
                        .gallery); // You can use ImageSource.camera for the camera.
                var path = "/assets/db";
                Directory? directory;
                try {
                  if(Platform.isAndroid) {
                    directory = (await getExternalStorageDirectory());
                  } else {
                    directory = (await getApplicationDocumentsDirectory());
                  }
                } catch (err) {
                  if (kDebugMode) {
                    print("Cannot get download folder path");
                  }
                }

                String projectName = await Util.getProjectName();
                if (!Directory("${directory!.path}/$projectName").existsSync()) {
                  Directory("${directory.path}/$projectName").create(recursive: true);
                }

                directory = Directory("${directory.path}/$projectName");

                final varid = myuuid.v4();
                path = "${directory.path}/$varid.jpeg";

                try{
                  print("res : ${pickedImage!.path}");
                  print("path : $path");

                  /*final imageFile = File(res.path);


                                          final srcimage = img.decodeImage(imageFile.readAsBytesSync());
                                          img.Image resizedImage = img.copyResize(srcimage!, width: 1600, height: 900);
                                          */



                  File(pickedImage!.path).copy( path);

                  if(await File(path).existsSync()){
                    print("File found");
                  }

                }catch(e){
                  Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }



                var mylist = (ans['data'] as List);
                int index = mylist.indexWhere(
                        (element) =>
                    element['question_id'] ==
                        widget.question.questionID);
                if (index == -1) {
                  mylist.add({
                    "value": path.split("/").last,
                    "question_id":
                    widget.question.questionID,
                    "variable": widget.question.variable
                  });
                } else {
                  mylist[index] = {
                    "value": path.split("/").last,
                    "question_id":
                    widget.question.questionID,
                    "variable": widget.question.variable
                  };
                }
                ans['data'] = mylist;

                navKey.currentState
                    ?.popUntil(ModalRoute.withName(widget.getBack));
              },
              child: const Text('Pick image from gallery')),
          ElevatedButton(
              onPressed: () {
                navKey.currentState?.push(
                  MaterialPageRoute(
                      settings: const RouteSettings(name: "/camera/camera"),
                      builder: (context) => CameraWidget(
                          question: widget.question,
                          surveyId: widget.surveyId,
                          backUri: widget.getBack)),
                );
              },
              child: const Text('Click image from camera')),
        ]),
      ),
    );
  }
}
