import 'dart:convert';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

// written by Gabriel
//
class CarbonStatController {
  double fromJsonScore(Map<String, dynamic> answer) {
    return switch (answer) {
      {
        'Score': double score,
      } =>
        score,
      _ => throw const FormatException('Failed to decode Klefulnech'),
    };
  }

  Future<String> fetchStats(String username) async {
    http.Request request = http.Request(
        "GET", Uri.parse('${SettingsController.address}/userScore'));
    request.body = jsonEncode(<String, String>{
      'User': username,
    });
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var response = await request.send();
    var result = await response.stream.transform(utf8.decoder).first;

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,

      return result;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load form');
    }
  }

  Future<String> fetchAverage() async {
    http.Request request =
        http.Request("GET", Uri.parse('${SettingsController.address}/average'));
    request.body = jsonEncode(<String, String>{}); // empty body
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    var response = await request.send();
    var result = await response.stream.transform(utf8.decoder).first;
    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception('Failed to load average score');
    }
  }

  Future<(List<String>, List<String>)> fetchCountries() async {
    http.Request request = http.Request(
        "GET", Uri.parse('${SettingsController.address}/comparison'));
    
    //this is currently hard coded, but it should have been dynamic.
    //we have all the countries and data, but i just never implemented a way to pick different ones.
    var countries = ["DNK", "SWE"];

    request.body = jsonEncode(<String, List<String>>{
      'landcodes': countries,
    });

    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    var response = await request.send();

    var result = await response.stream.transform(utf8.decoder).first;
    var result2 = jsonDecode(result);
    Map<String, String> res = {};
    for (int i = 0; i < countries.length; i++) {
      res.addAll({
        result2[i]['Country'].toString(): result2[i]['CarbonScore'].toString()
      });
    }
    if (response.statusCode == 200) {
      return (res.keys.toList(), res.values.toList());
    } else {
      throw Exception('Failed to load average score');
    }
  }
}
