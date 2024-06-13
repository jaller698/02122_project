import 'dart:convert';

import 'package:crypto/crypto.dart';

// written by Martin,
// class for carbon forms, in an object format instead of map, also contains conversion functions to and from maps
class CarbonForm {
  final String id;
  final String title;
  final List<CarbonQuestion> questions;

  const CarbonForm({
    this.id = '-1',
    required this.title,
    required this.questions,
  });

  factory CarbonForm.fromMap(Map<String, dynamic> json) {
    // carbon form pending and history controllers depends on an id, so in case the server fails to provide one,
    // an id will be created based on its own hash
    if (!json.containsKey('id')) {
      json['id'] =
          'HASH?${sha256.convert(utf8.encode(json.toString())).toString()}';
    }

    return switch (json) {
      {
        'id': String id,
        'title': String title,
        'questions': Map<String, dynamic> questions,
      } =>
        CarbonForm(
          id: id,
          title: title,
          questions: convertQuestionsFromMap(questions),
        ),
      _ => throw const FormatException('Failed to decode carbon form'),
    };
  }

  static List<CarbonQuestion> convertQuestionsFromMap(
      Map<String, dynamic> questions) {
    List<CarbonQuestion> questions0 =
        List<CarbonQuestion>.empty(growable: true);
    for (MapEntry element in questions.entries) {
      questions0.add(CarbonQuestion(
          title: element.key.toString().split('_').last,
          type: CarbonQuestionType.values
              .firstWhere((e) => e.name == element.value)));
    }

    return questions0;
  }

  static Map<String, dynamic> toMap(CarbonForm form) {
    Map<String, dynamic> m = <String, dynamic>{};

    m['id'] = form.id;
    m['title'] = form.title;
    m['questions'] = convertQuestionsToMap(form.questions);

    return m;
  }

  static Map<String, dynamic> convertQuestionsToMap(
      List<CarbonQuestion> questions) {
    Map<String, dynamic> m = <String, dynamic>{};

    for (var q in questions) {
      m[q.title] = q.type.name;
    }

    return m;
  }
}

// written by Martin,
// hardcoded enum for all supported question types
enum CarbonQuestionType {
  arbitrary,
  int,
  float,
  string,
  date,
  time,
  dateTime,
  dateRange,
  checkBox,
  dropDown,
  slider,
}

// written by Martin,
// helper class for carbon form to represent questions as objects
class CarbonQuestion {
  final String title;
  final CarbonQuestionType type;

  const CarbonQuestion({
    required this.title,
    required this.type,
  });
}
