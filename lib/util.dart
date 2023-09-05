import 'dart:convert';

List<String> tokenizeString(String input) {
  final List<String> tokens = [];

  // Define regex patterns for different categories
  final List<RegExp> patterns = [
    RegExp(r'[a-zA-Z]+'), // Alphabetical characters
    RegExp(r'\d+'), // Digits
    RegExp(r'\s+'), // Spaces
    RegExp(r'[!().]'), // Special characters group 1
    RegExp(r'[-=+]'), // Special characters group 2
    RegExp("[\\']"), // Special characters group 2
    RegExp('[\\"]'), // Special characters group 2
  ];

  for (int i = 0; i < input.length; i++) {
    bool tokenFound = false;
    for (RegExp pattern in patterns) {
      final match = pattern.firstMatch(input.substring(i));
      if (match != null && match.start == 0) {
        if (!match.group(0)!.contains(" ")) {
          tokens.add(match.group(0) ?? "");
        }
        i += match.group(0)!.length - 1;
        tokenFound = true;
        break;
      }
    }
    if (!tokenFound) {
      tokens.add(input[i]);
    }
  }

  return tokens;
}

String getValue(Map<String, dynamic> params, String value) {
  if (params['data'] == null) {
    return "0";
  }
  final datas = (params['data'] as List);
  for (var data in datas) {
    if (data['variable'] == value) {
      return data['value'].toString();
    }
  }
  return "0";
}

class ConditionAtomic {
  final String left;
  final String condition;
  final String right;

  const ConditionAtomic(this.left, this.condition, this.right);
  factory ConditionAtomic.fromJson(Map<String, dynamic> json) {
    return ConditionAtomic(
      json['left'],
      json['condition'],
      json['right'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'left': left,
      'condition': condition,
      'right': right,
    };
  }

  bool solve(Map<String, dynamic> parameters) {
    final pattern = RegExp(r'[a-zA-Z]+');

    print(left);
    print(right);

    print(getValue(parameters, left));
    var value = getValue(parameters, left);
    if (value == "") return false;

    int leftValue = (pattern.firstMatch(left) != null)
        ? int.parse(getValue(parameters, left))
        : int.parse(left);

    int rightValue = (pattern.firstMatch(right) != null)
        ? int.parse(getValue(parameters, right))
        : int.parse(right);

    if (condition == "<") {
      return leftValue < rightValue;
    } else if (condition == ">") {
      return leftValue > rightValue;
    } else if (condition == ">=") {
      return leftValue >= rightValue;
    } else if (condition == "<=") {
      return leftValue <= rightValue;
    } else if (condition == "=") {
      return leftValue == rightValue;
    } else {
      return leftValue != rightValue;
    }
  }
}

enum Sequence {
  and,
  or,
  ca,
  c;

  String toJson() => name;
  static Sequence fromJson(String json) => values.byName(json);
}

class Condition {
  List<Sequence>? sequences = [];
  List<ConditionAtomic>? cas = [];
  List<Condition>? cs = [];
  String condition;

  String? regex = "";

  Condition({required this.condition,this.sequences, this.cas, this.cs, this.regex});

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
	      condition: json['condition'],
        sequences: (json['sequences'] == null)
            ? null
            : (json['sequences'] as List)
                .map((data) => Sequence.fromJson(data['sequence']))
                .toList(),
        cas: (json['cas'] == null)
            ? null
            : (json['cas'] as List)
                .map((data) => ConditionAtomic.fromJson(
                    Map<String, dynamic>.from(data as Map)))
                .toList(),
        cs: (json['cs'] == null)
            ? null
            : (json['cs'] as List)
                .map((data) => Condition.fromJson(jsonDecode(data)))
                .toList(),
        regex: json['regex']);
  }

  Map<String, dynamic> toJson() {
    return {
	'condition':condition
    };
  }

  void setRegex(String reg) {
    regex = reg;
  }

  void addSequence(Sequence s) {
    sequences ??= [];
    sequences?.add(s);
  }

  void addCondition(Condition details) {
    sequences ??= [];
    cs ??= [];
    cs?.add(details);
    sequences?.add(Sequence.c);
  }

  void addConditionAtomic(ConditionAtomic details) {
    sequences ??= [];
    cas ??= [];
    cas?.add(details);
    sequences?.add(Sequence.ca);
  }

  bool solve(Map<String, dynamic> parameters) {
    int currentCA = 0;
    int currentC = 0;
    int current = 0;
    List<bool> stack = [];

    while (current < sequences!.length) {
      var s = sequences?[current];

      if (s == Sequence.ca) {
        stack.add(cas![currentCA++].solve(parameters));
      } else if (s == Sequence.c) {
        stack.add(cs![currentC++].solve(parameters));
      } else if (s == Sequence.and && sequences?[current + 1] == Sequence.ca) {
        bool left = stack.last;
        bool right = cas![currentCA++].solve(parameters);

        stack.removeLast();
        stack.add(left && right);
        current++;
      } else if (s == Sequence.and && sequences![current + 1] == Sequence.c) {
        bool left = stack.last;
        bool right = cs![currentC++].solve(parameters);
        stack.removeLast();
        stack.add(left && right);
        current++;
      } else if (s == Sequence.or && sequences![current + 1] == Sequence.ca) {
        bool left = stack.last;
        bool right = cas![currentCA++].solve(parameters);
        stack.removeLast();
        stack.add(left || right);
        current++;
      } else if (s == Sequence.or && sequences?[current + 1] == Sequence.c) {
        bool left = stack.last;
        bool right = cs![currentC++].solve(parameters);
        stack.removeLast();
        stack.add(left || right);
        current++;
      }
      current++;
    }
    return stack.first;
  }

  bool solveRegex(String value) {
    return !RegExp(regex!).hasMatch(value);
  }
}

class Parser {
  List<String> tokens;
  int index = 0;

  Parser(this.tokens);

  Condition parse() {
	String input = "";
      for (var token in tokens) {
        input+= token;
      }
    List<Condition> condition = [Condition(condition:input)];

    List<String> params = [];

    if (tokens[0] == "REGEX") {
      Condition my = Condition(condition:input);
      String regex = "";

      for (var token in tokens.skip(1)) {
        regex += token;
      }

      my.regex = regex;
      return my;
    }

    while (index < tokens.length) {
      if (tokens[index] == "\$") {
        params.add(tokens[index + 2]);
        index += 3;

        if (tokens[index + 1] == ">") {
          if (tokens[index + 2] == "=") {
            if (tokens[index + 3] == "\$") {
              params.add(tokens[index + 5]);
              index += 6;
            } else {
              params.add(tokens[index + 3]);
              index += 3;
            }
            var right = params.last;
            params.removeLast();

            var left = params.last;
            params.removeLast();
            ConditionAtomic ca = ConditionAtomic(left, ">=", right);

            condition.last.addConditionAtomic(ca);
          } else {
            if (tokens[index + 2] == "\$") {
              params.add(tokens[index + 4]);
              index += 5;
            } else {
              params.add(tokens[index + 2]);
              index += 2;
            }
            var right = params.last;
            params.removeLast();

            var left = params.last;
            params.removeLast();
            ConditionAtomic ca = ConditionAtomic(left, ">", right);
            condition.last.addConditionAtomic(ca);
          }
        } else if (tokens[index + 1] == "<") {
          if (tokens[index + 2] == "=") {
            if (tokens[index + 3] == "\$") {
              params.add(tokens[index + 5]);
              index += 6;
            } else {
              params.add(tokens[index + 3]);
              index += 3;
            }
            var right = params.last;
            params.removeLast();

            var left = params.last;
            params.removeLast();
            ConditionAtomic ca = ConditionAtomic(left, "<=", right);
            condition.last.addConditionAtomic(ca);
          } else {
            if (tokens[index + 2] == "\$") {
              params.add(tokens[index + 4]);
              index += 5;
            } else {
              params.add(tokens[index + 2]);
              index += 2;
            }
            var right = params.last;
            params.removeLast();

            var left = params.last;
            params.removeLast();
            ConditionAtomic ca = ConditionAtomic(left, "<", right);
            condition.last.addConditionAtomic(ca);
          }
        } else if (tokens[index + 1] == "!") {
          if (tokens[index + 3] == "\$") {
            params.add(tokens[index + 5]);
            index += 6;
          } else {
            params.add(tokens[index + 3]);
            index += 3;
          }
          var right = params.last;
          params.removeLast();

          var left = params.last;
          params.removeLast();
          ConditionAtomic ca = ConditionAtomic(left, "!=", right);
          condition.last.addConditionAtomic(ca);
        } else if (tokens[index + 1] == "=") {
          if (tokens[index + 2] == "\$") {
            params.add(tokens[index + 4]);
            index += 6;
          } else {
            params.add(tokens[index + 2]);
            index += 2;
          }

          var right = params.last;
          params.removeLast();

          var left = params.last;
          params.removeLast();
          ConditionAtomic ca = ConditionAtomic(left, "=", right);
          condition.last.addConditionAtomic(ca);
        }
      } else if (tokens[index] == "or") {
        condition.last.addSequence(Sequence.or);
      } else if (tokens[index] == "and") {
        condition.last.addSequence(Sequence.and);
      } else if (tokens[index] == "(") {
        condition.add(Condition(condition:input));
      } else if (tokens[index] == ")") {
        Condition temp = condition.last;
        condition.removeLast();
        condition.last.addCondition(temp);
      }
      if (params.length == 2) {
        params.clear();
      }

      index++;
    }

    return condition.first;
  }
}

Condition getCondition(String input) {
  Condition condition = Condition(condition:input);

  List<String> tokens = tokenizeString(input);

  if (tokens.isEmpty) {
    return condition;
  }

  if (tokens[0] == "REGEX") {
    String regex = "";

    for (var token in tokens.skip(1)) {
      regex += token;
    }

    condition.setRegex(regex);
  } else {
    Parser pareser = Parser(tokens);

    condition = pareser.parse();
  }

  return condition;
}
