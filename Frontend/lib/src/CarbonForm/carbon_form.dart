class CarbonForm {
  final String title;
  final List<CarbonQuestion> questions;

  const CarbonForm({
    required this.title,
    required this.questions,
  });

  factory CarbonForm.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'questions': Map<String, dynamic> questions,
      } =>
        CarbonForm(
          title: title,
          questions: convertQuestionsFromJson(questions),
        ),
      _ => throw const FormatException('Failed to decode carbon form'),
    };
  }

  static List<CarbonQuestion> convertQuestionsFromJson(
      Map<String, dynamic> questions) {
    List<CarbonQuestion> questions0 =
        List<CarbonQuestion>.empty(growable: true);
    for (MapEntry element in questions.entries) {
      questions0.add(CarbonQuestion(
          title: element.key,
          type: CarbonQuestionType.values
              .firstWhere((e) => e.name == element.value)));
    }

    return questions0;
  }

  static Map<String, dynamic> toJson(CarbonForm form) {
    Map<String, dynamic> m = <String, dynamic>{};

    m['title'] = form.title;
    m['questions'] = convertQuestionsToJson(form.questions); // TODO

    return m;
  }

  static Map<String, dynamic> convertQuestionsToJson(
      List<CarbonQuestion> questions) {
    Map<String, dynamic> m = <String, dynamic>{};

    for (var q in questions) {
      m[q.title] = q.type.name;
    }

    return m;
  }
}

enum CarbonQuestionType {
  arbitrary,
  int,
  float,
  string,
  date,
  time,
  dateTime,
}

class CarbonQuestion {
  final String title;
  final CarbonQuestionType type;

  const CarbonQuestion({
    required this.title,
    required this.type,
  });
}

class CarbonFormAnswer {
  final String title;
  final List<String> answers;

  const CarbonFormAnswer({
    required this.title,
    required this.answers,
  });

  factory CarbonFormAnswer.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'questions': List<String> answers,
      } =>
        CarbonFormAnswer(
          title: title,
          answers: answers,
        ),
      _ => throw const FormatException('Failed to encode carbon form'),
    };
  }
}
