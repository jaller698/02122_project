import 'dart:convert';

import 'package:carbon_footprint/src/user_controller.dart';
import 'package:http/http.dart' as http;

import '../Settings/settings_controller.dart';

// written by Christian
// Controller for fetching carbon score history
class CarbonHistoryController {
  double maxScore = 0;
  // first use a POST request to get the history from the server
  Future<List<CarbonHistoricItem>> fetchHistory() async {
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
    List<CarbonHistoricItem> history = [];

    // if the server returns a 200 OK response, parse the JSON
    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(responseBody);
      for (var item in json) {
        if (item['CarbonScore'] > maxScore) {
          maxScore = item['CarbonScore'].toDouble();
        }
        history.add(CarbonHistoricItem(item['Date'], item['CarbonScore']));
      }
    } else {
      throw Exception('Failed to load form');
    }

    // sort history by date
    history.sort((a, b) => a.date.compareTo(b.date));

    return history;
  }
}

// class for storing a single item in the carbon score history
// used to better parse the JSON response
class CarbonHistoricItem {
  final String date;
  final int score;

  CarbonHistoricItem(this.date, this.score);
}
