
import 'dart:convert';
import 'dart:io';

import 'package:carbon_footprint/src/user_controller.dart';
import 'package:http/http.dart' as http;

import '../Settings/settings_controller.dart';

class CarbonHistoryController {
  double maxScore = 0;
  Future<List<carbonHistoricItem>> fetchHistory() async {

    http.Request request = http.Request(
        "GET", Uri.parse('${SettingsController.address}/carbonScoreHistory'));
    request.body = jsonEncode(<String, String>{
      'User': UserController().username,
    });
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var response = await request.send();
    var responseBody = await response.stream.transform(utf8.decoder).first;
    List<carbonHistoricItem> history = [];

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(responseBody);
      for (var item in json) {
        if (item['CarbonScore'] > maxScore) {
          maxScore = item['CarbonScore'].toDouble();
        }
        history.add(carbonHistoricItem(item['Date'], item['CarbonScore']));
      }
    } else {
      throw Exception('Failed to load form');
    }

    return history;
  }

}

class carbonHistoricItem {
  final String date;
  final int score;

  carbonHistoricItem(this.date, this.score);
}