import 'dart:convert';

import 'package:crypto/crypto.dart';

// written by Martin
// class for handling completed carbon forms, so instead of a list of questions it has a map of anwsers
// also handles all from and to map conversion, for further json encoding
class CarbonFormAnswer {
  final String id;
  final String title;
  final String user;
  final Map<String, dynamic> anwsers;

  const CarbonFormAnswer({
    this.id = '-1',
    required this.title,
    required this.user,
    required this.anwsers,
  });

  factory CarbonFormAnswer.fromMap(Map<String, dynamic> json) {
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
        'userID': String user,
        'answers': Map<String, dynamic> anwsers,
      } =>
        CarbonFormAnswer(
          id: id,
          title: title,
          user: user,
          anwsers: anwsers,
        ),
      _ => throw FormatException('Failed to decode carbon form: $json'),
    };
  }

  static Map<String, dynamic> toMap(CarbonFormAnswer form) {
    Map<String, dynamic> m = <String, dynamic>{};

    m['id'] = form.id;
    m['title'] = form.title;
    m['userID'] = form.user;
    m['answers'] = form.anwsers;

    return m;
  }
}
