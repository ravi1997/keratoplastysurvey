import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:camera_universal/camera_universal.dart';
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/controller/util.dart';
import 'package:keratoplastysurvey/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image/image.dart' as img;

class CircleRevealClipper extends CustomClipper<Rect> {
  CircleRevealClipper();

  @override
  Rect getClip(Size size) {
    final centerx = size.width * 0.5;
    final centery = size.height * 0.5;

    final recwidthrel = size.width * 0.90;
    final recheightrel = size.height * 0.90;

    final width = min(recheightrel,recwidthrel);



    final left = centerx - width/2;
    final top = centery - width/2;


    return Rect.fromLTWH(
      left,
      top,
      width,
      width,
    );
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
  final GlobalKey globalKey = GlobalKey();
  String errorMsg = "";
  bool submit = false;

  void setSubmit(bool val){
      // Your code that calls setState or modifies the widget tree
      setState(() {
        submit = val;
        // Update the state here
      });

  }

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
    if(submit){
      navKey.currentState?.popUntil(
          ModalRoute.withName(widget.backUri));
    }
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
                  color: Color.fromARGB(0, 0, 0, 0),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {},
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.more_horiz_rounded,
                          size: 30,
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

                          final imageFile = File(res!.path);

                          final srcimage = img.decodeImage(imageFile.readAsBytesSync());
                          img.Image resizedImage = img.copyResize(srcimage!, width: 900 , height: 1600);
                          const centerx = 450;
                          const centery = 800;

                          const recwidthrel = 900 * 0.90;
                          const recheightrel = 1600 * 0.90;

                          final width = min(recheightrel,recwidthrel);

                          img.Image croppedImage =img.copyCropCircle(resizedImage,centerX: centerx,centerY: centery,radius: (width/2).round());
                          await img.encodeJpgFile(res.path,croppedImage);

                          bool shouldPop = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
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
                                              Navigator.of(context).pop(false);
                                            },
                                            icon:
                                            const Icon(Icons.close_rounded),
                                            color: Colors.redAccent,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible: errorMsg.isEmpty,
                                      replacement: Text(errorMsg),
                                      child: Image.file(
                                        File(res.path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
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
                                          if (kDebugMode) {
                                            print("res : ${res.path}");
                                            print("path : $path");
                                          }

                                          File(res.path).copy( path);

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

                                        Navigator.of(context).pop(true);

                                      },
                                      child: const Text("Submit"),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                          ?? false
                          ;
                          if (shouldPop != null && shouldPop) {

                            navKey.currentState?.popUntil(
                                ModalRoute.withName(widget.backUri));
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(14),
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
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Icon(
                        Icons.sync,
                        size: 30,
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
