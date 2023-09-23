
import 'package:keratoplastysurvey/configuration.dart';
import 'package:keratoplastysurvey/util.dart';

List<String> toListString(List<dynamic> datas) {
  List<String> dataString = [];

  for (var data in datas) {
    dataString.add(data);
  }

  return dataString;
}

class User {
  String name = '';
  String loginId = '';
  String password = '';
  String? token = '';
  int? id = 0;
  String? type = "";
  bool rememberMe = false;
  bool signedIn = false;

  User(
      {required this.name,
      required this.loginId,
      required this.password,
      required this.rememberMe,
      required this.signedIn,
      this.id,
      this.token,
      this.type});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'] ?? "",
        loginId: json['loginId'] ?? "",
        password: json['password'] ?? "",
        rememberMe: json['rememberMe'] ?? false,
        signedIn: json['signedIn'] ?? false,
        id: json['id'] ?? 0,
        type: json['type'] ?? "",
        token: json['token'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'loginId': loginId,
      'password': password,
      'rememberMe': rememberMe,
      'signedIn': signedIn,
      'id': id,
      'type': type,
      'token': token,
    };
  }
}

enum QuestionType {
  textfield,
  dropdown,
  radiobutton,
  datePicker,
  datePickerMonth,
  datePickerYear,
  imagePicker;

  String toJson() => name;
  static QuestionType fromJson(String json) => values.byName(json);
}

List<Map<String, String>> getValueRange(name, values) {
  List<Map<String, String>> result = [];
  String myname;

  if (name == null) {
    myname = myuuid.v4();
  } else {
    myname = name;
  }

  for (var value in values) {
    result.add({'name': myname, 'value': value});
  }

  return result;
}

List<String> getValueRangeList(valueRange) {
  List<String> result = [];
  for (var value in valueRange) {
    result.add(value['value']);
  }
  return result;
}

class Question {
  String? questionID = myuuid.v4();
  String question;
  String variable;
  String? hint;
  bool? required;
  Condition? visibilityCondition;
  Condition? constraint;
  String? constraintMessage;
  String? defaultValue;
  bool? lastSaved;
  QuestionType type;
  String valueType;
  List<String> valueRange;
  String? valueRangeName;

  Question(
      {questionID,
      required this.question,
      required this.variable,
      this.hint,
      this.required,
      this.visibilityCondition,
      this.constraint,
      this.constraintMessage,
      this.defaultValue,
      this.lastSaved,
      required this.type,
      required this.valueType,
      this.valueRangeName,
      required this.valueRange}):questionID=(questionID==null)?myuuid.v4():questionID;

  factory Question.fromJson(Map<String, dynamic> json) {
    print(json['constraint']);
    return Question(
      questionID: json['questionID'],
      question: json['question'],
      variable: json['variable'],
      hint: json['hint'],
      required: json['required'],
      visibilityCondition: (json['visibilityCondition'] == null)
          ? null
          : (json['visibilityCondition']['condition'] == null)
              ? null
              : getCondition(json['visibilityCondition']['condition']),
      constraint: (json['constraint'] == null)
          ? null
          : (json['constraint']['condition'] == null)
              ? null
              : getCondition(json['constraint']['condition']),
      constraintMessage: json['constraintMessage'],
      defaultValue: json['defaultValue'],
      lastSaved: json['lastSaved'],
      type: QuestionType.fromJson(json['type']),
      valueType: json['valueType'],
      valueRangeName:
          (json['valueRange'].length > 0) ? json['valueRange']['name'] : "",
      valueRange: getValueRangeList(json['valueRange']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionID': questionID,
      'question': question,
      'variable': variable,
      'hint': hint,
      'required': required,
      'visibilityCondition': (visibilityCondition == null)
          ? null
          : visibilityCondition?.toJson()['condition'],
      'constraint':
          (constraint == null) ? null : constraint?.toJson()['condition'],
      'constraintMessage': constraintMessage,
      'defaultValue': defaultValue,
      'lastSaved': lastSaved,
      'type': type.toJson(),
      'valueType': valueType,
      'valueRange': getValueRange(valueRangeName, valueRange),
    };
  }
}

class Jump {
  int sectionID;
  Condition? condition;

  Jump({required this.sectionID, this.condition});

  factory Jump.fromJson(Map<String, dynamic> json) {
    return Jump(
      sectionID: json['sectionID'],
      condition: getCondition(json['condition']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionID': sectionID,
      'condition':
          (condition == null) ? null : condition?.toJson()['condition'],
    };
  }
}

class Section {
  int sectionID;
  String sectionName;
  List<Question> questions;
  List<Jump> jumps;
  bool? finalSection;
  Section(
      {required this.sectionID,
      required this.sectionName,
      required this.questions,
      required this.jumps,
      this.finalSection});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      sectionID: json['sectionID'],
      sectionName: json['sectionName'],
      questions: (json['questions'] as List)
          .map((data) =>
              Question.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList(),
      jumps: (json['jumps'] as List)
          .map((data) => Jump.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList(),
      finalSection: json['finalSection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sectionID': sectionID,
      'sectionName': sectionName,
      'questions': questions.map((data) => data.toJson()).toList(),
      'jumps': jumps.map((data) => data.toJson()).toList(),
      'finalSection': finalSection,
    };
  }
}

enum SurveyStatus {
  active,
  deactive;

  String toJson() => name;
  static SurveyStatus fromJson(String json) => values.byName(json);
}

class Survey {
  String? surveyID = myuuid.v1();
  String surveyName;
  String description;
  List<Section> sections;
  DateTime createAt;
  DateTime activeFrom;
  DateTime activeTill;

  Survey({
    surveyID,
    required this.surveyName,
    required this.description,
    required this.sections,
    required this.createAt,
    required this.activeFrom,
    required this.activeTill,
  }):surveyID=(surveyID==null)?myuuid.v4():surveyID;

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      surveyID: json['surveyID'],
      surveyName: json['surveyName'],
      createAt: DateTime.parse(json['createAt']),
      activeFrom: DateTime.parse(json['activeFrom']),
      activeTill: DateTime.parse(json['activeTill']),
      description: json['description'],
      sections: (json['sections'] as List)
          .map((data) =>
              Section.fromJson(Map<String, dynamic>.from(data as Map)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'surveyID': surveyID,
      'surveyName': surveyName,
      'sections': sections.map((section) => section.toJson()).toList(),
      'createAt': createAt.toIso8601String(),
      'activeFrom': activeFrom.toIso8601String(),
      'activeTill': activeTill.toIso8601String(),
      'description': description,
    };
  }
}
