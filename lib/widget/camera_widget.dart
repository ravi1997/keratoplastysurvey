import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:camera_universal/camera_universal.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:path_provider/path_provider.dart';

class CircleRevealClipper extends CustomClipper<Rect> {
  CircleRevealClipper();

  @override
  Rect getClip(Size size) {
    final epicenter = Offset(size.width * 0.9, size.height * 0.9);

    // Calculate distance from epicenter to the top left corner to make sure clip the image into circle.

    final distanceToCorner = epicenter.dy;

    final radius = distanceToCorner / 2;
    final diameter = radius * 0.90;

    return Rect.fromLTWH(epicenter.dx - radius + size.width * 0.1,
        epicenter.dy - radius - size.height * 0.2, diameter, diameter);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}

class CameraWidget extends StatefulWidget {
  const CameraWidget(
      {super.key,
      required this.question,
      required this.backUri,
      required this.surveyId});

  final Question question;
  final String backUri;
  final String surveyId;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController cameraController = CameraController();
  String errorMsg = "";
  @override
  void initState() {
    super.initState();
    task();
  }

  Future<void> task() async {
    try {
      await cameraController.initializeCameras();
      await cameraController.initializeCamera(
        setState: setState,
      );

      await cameraController.activateCamera(
        setState: setState,
        mounted: () {
          return mounted;
        },
      );
    } catch (e) {
      setState(() {
        errorMsg = e.toString();
      });
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.question.question),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(),
        child: Stack(
          children: [
            Container(
              child: ClipOval(
                  clipper: CircleRevealClipper(),
                  child: Visibility(
                    visible: errorMsg.isEmpty,
                    replacement: Text(errorMsg),
                    child: Camera(
                      cameraController: cameraController,
                      onCameraNotInit: (context) {
                        return const Text("Camera not init");
                      },
                      onCameraNotSelect: (context) {
                        return const Text("Camera not select");
                      },
                      onCameraNotActive: (context) {
                        return const Text("Camera not active");
                      },
                      onPlatformNotSupported: (context) {
                        return const Text("Camera not supported");
                      },
                    ),
                  )),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 1 / 5,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(102, 0, 0, 0),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Future(() async {
                          var res = await cameraController.action_take_picture(
                            onCameraNotInit: () {},
                            onCameraNotSelect: () {},
                            onCameraNotActive: () {},
                          );

                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'PICTURE',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon:
                                                const Icon(Icons.close_rounded),
                                            color: Colors.redAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipOval(
                                      clipper: CircleRevealClipper(),
                                      child: Visibility(
                                        visible: errorMsg.isEmpty,
                                        replacement: Text(errorMsg),
                                        child: Image.file(
                                          File(res!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        var path = "/assets/db";
                                        Directory? directory;
                                        try {
                                          directory = await getApplicationDocumentsDirectory();
                                        } catch (err) {
                                          if (kDebugMode) {
                                            print("Cannot get download folder path");
                                          }
                                        }

                                        String projectName = await Util.getProjectName();

                                        if (!Directory("${directory!.path}/$projectName").existsSync()) {
                                          Directory("${directory.path}/$projectName").create(recursive: true);
                                        }else{
                                          Directory("${directory.path}/$projectName").delete(recursive: true);
                                          Directory("${directory.path}/$projectName").create(recursive: true);
                                        }
                                        final varid = myuuid.v4();
                                        directory = Directory(
                                            "${directory.path}/$projectName/${widget.surveyId}/$varid");

                                        if (!directory.existsSync()){
                                          directory.create(recursive: true);
                                        }
                                        path = directory.path;
					print(res.path);
                                        File(res.path).copy(path);
                                        var mylist = (ans['data'] as List);
                                        int index = mylist.indexWhere(
                                            (element) =>
                                                element['question_id'] ==
                                                widget.question.questionID);
                                        if (index == -1) {
                                          mylist.add({
                                            "value": varid,
                                            "question_id":
                                                widget.question.questionID,
                                            "variable": widget.question.variable
                                          });
                                        } else {
                                          mylist[index] = {
                                            "value": varid,
                                            "question_id":
                                                widget.question.questionID,
                                            "variable": widget.question.variable
                                          };
                                        }
                                        ans['data'] = mylist;

                                        navKey.currentState?.popUntil(
                                            ModalRoute.withName(
                                                widget.backUri));
                                      },
                                      child: const Text("Submit"),
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        int cameraId = 1;
                        var res = cameraController.camera_mobile_datas;
                        if (cameraController.camera_id > 1) {
                          cameraId = 1;
                        } else {
                          cameraId = res.length;
                        }
                        await cameraController.action_change_camera(
                          cameraId: cameraId,
                          setState: setState,
                          mounted: () {
                            return mounted;
                          },
                          onCameraNotInit: () {},
                          onCameraNotSelect: () {},
                          onCameraNotActive: () {},
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(24),
                      ),
                      child: const Icon(
                        Icons.sync,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
