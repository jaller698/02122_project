class CarbonForm {
  final int id;
  final String title;
  final List<CarbonQuestion> questions;

  const CarbonForm({
    this.id = -1,
    required this.title,
    required this.questions,
  });

  factory CarbonForm.fromMap(Map<String, dynamic> json) {
    print(json);
    return switch (json) {
      {
        'title': String title,
        'questions': Map<String, dynamic> questions,
      } =>
        CarbonForm(
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

class CarbonQuestion {
  final String title;
  final CarbonQuestionType type;

  const CarbonQuestion({
    required this.title,
    required this.type,
  });
}
