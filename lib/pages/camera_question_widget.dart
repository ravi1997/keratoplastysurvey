import 'dart:io';

import 'package:flutter/material.dart';
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
                String projectName = await Util.getProjectName();
                var path = "/assets/db";
                Directory? directory;
                try {
                  if (Platform.isAndroid) {
                    directory = await getExternalStorageDirectory();
                  } else {
                    directory = await getApplicationDocumentsDirectory();
                  }
                } catch (err) {
                  if (kDebugMode) {
                    print("Cannot get download folder path");
                  }
                }
                if (!Directory("${directory!.path}/$projectName")
                    .existsSync()) {
                  Directory("${directory.path}/$projectName")
                      .createSync(recursive: true);
                }
                final varid = myuuid.v4();
                directory = Directory(
                    "${directory.path}/$projectName/${widget.surveyId}/$varid");
                path = directory.path;
                File(pickedImage!.path).copy(path);
                var mylist = (ans['data'] as List);
                int index = mylist.indexWhere((element) =>
                    element['question_id'] == widget.question.questionID);
                if (index == -1) {
                  mylist.add({
                    "value": varid,
                    "question_id": widget.question.questionID,
                    "variable": widget.question.variable
                  });
                } else {
                  mylist[index] = {
                    "value": varid,
                    "question_id": widget.question.questionID,
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
