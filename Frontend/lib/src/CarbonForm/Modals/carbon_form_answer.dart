class CarbonFormAnswer {
  final String title;
  final Map<String, dynamic> anwsers;

  const CarbonFormAnswer({
    required this.title,
    required this.anwsers,
  });

  factory CarbonFormAnswer.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'questions': Map<String, dynamic> anwsers,
      } =>
        CarbonFormAnswer(
          title: title,
          anwsers: anwsers,
        ),
      _ => throw const FormatException('Failed to decode carbon form'),
    };
  }

  static Map<String, dynamic> toJson(CarbonFormAnswer form) {
    Map<String, dynamic> m = <String, dynamic>{};

    m['title'] = form.title;
    m['anwsers'] = form.anwsers.toString();

    return m;
  }
}
