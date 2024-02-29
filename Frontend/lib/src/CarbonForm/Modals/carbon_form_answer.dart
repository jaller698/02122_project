class CarbonFormAnwser {
  final String title;
  final Map<String, dynamic> anwsers;

  const CarbonFormAnwser({
    required this.title,
    required this.anwsers,
  });

  factory CarbonFormAnwser.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'questions': Map<String, dynamic> anwsers,
      } =>
        CarbonFormAnwser(
          title: title,
          anwsers: anwsers,
        ),
      _ => throw const FormatException('Failed to decode carbon form'),
    };
  }

  static Map<String, dynamic> toJson(CarbonFormAnwser form) {
    Map<String, dynamic> m = <String, dynamic>{};

    m['title'] = form.title;
    m['anwsers'] = form.anwsers;

    return m;
  }
}
