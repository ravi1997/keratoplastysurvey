import 'package:keratoplastysurvey/controller/API/answer_api.dart';
import 'package:keratoplastysurvey/controller/API/auth.dart';
import 'package:keratoplastysurvey/controller/API/from_hive.dart';
import 'package:keratoplastysurvey/controller/API/to_hive.dart';

class API {
  static final Auth auth = Auth();
  static final ToHive toHive = ToHive();
  static final FromHive fromHive = FromHive();
  static final AnswerAPI answerapi = AnswerAPI();
}
