import 'package:keratoplastysurvey/controller/API/answer_api.dart';
import 'package:keratoplastysurvey/controller/API/auth.dart';
import 'package:keratoplastysurvey/controller/API/from_file.dart';
import 'package:keratoplastysurvey/controller/API/to_file.dart';

class API {
  static final Auth auth = Auth();
  static final ToFile toFile = ToFile();
  static final FromFile fromFile = FromFile();
  static final AnswerAPI answerapi = AnswerAPI();
}
