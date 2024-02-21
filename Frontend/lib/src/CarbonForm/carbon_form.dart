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
          questions: convertQuestions(questions),
        ),
      _ => throw const FormatException('Failed to decode carbon form'),
    };
  }

  static List<CarbonQuestion> convertQuestions(Map<String, dynamic> questions) {
    List<CarbonQuestion> questions0 = List<CarbonQuestion>.empty(growable: true);
    for (MapEntry element in questions.entries) {
      questions0.add(CarbonQuestion(title: element.key, type: CarbonQuestionType.values.firstWhere((e) => e.name == element.value)));
    }

    return questions0;
  }
}

enum CarbonQuestionType {
  number,
  text,
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