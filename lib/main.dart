import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keratoplastysurvey/api.dart' as my_api;
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/pages/home_page.dart';
import 'package:keratoplastysurvey/pages/login_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kDebugMode;

void testData({required my_api.HiveInterface hiveInterface}) {
  surveys.clear();

  surveys = my_api.API.getSurveyData(hiveInterface: hiveInterface);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // HIVE ENCRYPTION----------------------------------------
  const secureStorage = FlutterSecureStorage();

  final encryptionKey = await secureStorage.read(key: 'key');
  if (encryptionKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64Encode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptKey = base64Url.decode(key!);
  if (kDebugMode) {
    print('Encryption key: $encryptKey');
  }
  // HIVE ENCRYPTION----------------------------------------

  // HIVE INIT---------------------------------------------
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

  String projectName = await my_api.getProjectName();

  if (!Directory("${directory!.path}/$projectName").existsSync()) {
    Directory("${directory.path}/$projectName").createSync(recursive: true);
  }
  directory = Directory("${directory.path}/$projectName");
  path = directory.path;
  if (kDebugMode) {
    print("path : $path");
  }

  //Hive.init(path);
  await Hive.initFlutter();
  // HIVE INIT---------------------------------------------

  var userBox = await Hive.openBox('user',
      path: path, encryptionCipher: HiveAesCipher(encryptKey));
  var surveyBox = await Hive.openBox('survey',
      path: path, encryptionCipher: HiveAesCipher(encryptKey));
  var answersBox = await Hive.openBox('answers',
      path: path, encryptionCipher: HiveAesCipher(encryptKey));

  my_api.HiveInterface hiveInterface = my_api.HiveInterface(collection: {
    'user': userBox,
    'survey': surveyBox,
    'answers': answersBox,
  });
  try {
    await my_api.API.loadUser(hiveInterface);
  } catch (e, stack) {
    if (kDebugMode) {
      print(e);
      print(stack);
    }
  }

  File file = await File('$path/env.json')
      .create(recursive: true, exclusive: true)
      .then((File file) {
    file.writeAsStringSync(json.encode({"baseurl": "http://127.0.0.1:5000"}));
    return file;
  }).onError((error, stackTrace) {
    return File('$path/env.json');
  });

  String jsonText = await file.readAsString();
  final data = await json.decode(jsonText);

  configuration = Configuration(baseURL: data['baseurl']);
/*   

  my_api.API.uploadSurvey(hiveInterface: hiveInterface, survey: keratoplasty);
  testData(hiveInterface: hiveInterface);
 */
  if (user.token != "") {
    my_api.API.sync(hiveInterface: hiveInterface);
  } else {
    my_api.API.getSurveyData(hiveInterface: hiveInterface);
  }

  if (kDebugMode) {
    print("User id : ${user.loginId}");
  }

  runApp(MyApp(hiveInterface: hiveInterface));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.hiveInterface}) : super(key: key);

  final my_api.HiveInterface hiveInterface;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Keratoplasty Survey',
      navigatorKey: navKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: "/LoginPage",
      routes: {
        "/LoginPage": (context) => LoginPage(hiveInterface: hiveInterface),
        "/HomePage": (context) => HomePage(hiveInterface: hiveInterface),
      },
      home: (user.signedIn)
          ? HomePage(hiveInterface: hiveInterface)
          : LoginPage(hiveInterface: hiveInterface),
    );
  }
}
