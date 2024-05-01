class CarbonFormAnswer {
  final int id;
  final String title;
  final String user;
  final Map<String, dynamic> anwsers;

  const CarbonFormAnswer({
    this.id = -1,
    required this.title,
    required this.user,
    required this.anwsers,
  });

  factory CarbonFormAnswer.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'userID': String user,
        'questions': Map<String, dynamic> anwsers,
      } =>
        CarbonFormAnswer(
          title: title,
          user: user,
          anwsers: anwsers,
        ),
      _ => throw const FormatException('Failed to decode carbon form'),
    };
  }

  static Map<String, dynamic> toMap(CarbonFormAnswer form) {
    Map<String, dynamic> m = <String, dynamic>{};

    m['title'] = form.title;
    m['userID'] = form.user;
    m['answers'] = form.anwsers;

    return m;
  }
}
