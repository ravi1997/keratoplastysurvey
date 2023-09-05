import 'dart:io';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:camera_universal/camera_universal.dart';
import 'package:keratoplastysurvey/configuration.dart';
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
  final int surveyId;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  CameraController cameraController = CameraController();
  String error_msg = "";
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
    } catch (e, stack) {
      print(e);
      print(stack);
      setState(() {
        error_msg = "error";
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
                    visible: error_msg.isEmpty,
                    replacement: Text(error_msg),
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

                          print(res?.path);

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
                                        visible: error_msg.isEmpty,
                                        replacement: Text(error_msg),
                                        child: Image.file(
                                          File(res!.path),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        String projectName =
                                            await my_api.getProjectName();
                                        var path = "/assets/db";
                                        Directory? directory;
                                        try {
                                          if (Platform.isAndroid) {
                                            directory =
                                                await getExternalStorageDirectory();
                                          } else {
                                            directory =
                                                await getApplicationDocumentsDirectory();
                                          }
                                        } catch (err) {
                                          if (kDebugMode) {
                                            print(
                                                "Cannot get download folder path");
                                          }
                                        }
                                        if (!Directory(
                                                "${directory!.path}/$projectName")
                                            .existsSync()) {
                                          Directory(
                                                  "${directory.path}/$projectName")
                                              .createSync(recursive: true);
                                        }
                                        final varid = uuid.v4();
                                        directory = Directory(
                                            "${directory.path}/$projectName/${widget.surveyId}/$varid");
                                        path = directory.path;
                                        File(res!.path).copy(path);
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
                        int camera_id = 1;
                        var res = cameraController.camera_mobile_datas;
                        print(cameraController.camera_id);
                        print(res.length);
                        if (cameraController.camera_id > 1) {
                          camera_id = 1;
                        } else {
                          camera_id = res.length;
                        }
                        await cameraController.action_change_camera(
                          cameraId: camera_id,
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
