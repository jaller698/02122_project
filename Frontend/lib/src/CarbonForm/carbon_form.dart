class CarbonForm {
  final String title;
  final Map<String, dynamic> questions;

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
          questions: questions,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}

class CarbonFormAnswer {
  final String title;
  final Map<String, dynamic> answers;

  const CarbonFormAnswer({
    required this.title,
    required this.answers,
  });

  factory CarbonFormAnswer.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'questions': Map<String, dynamic> questions,
      } =>
        CarbonFormAnswer(
          title: title,
          answers: questions,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}