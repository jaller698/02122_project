import 'dart:convert';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

class DashboardController {
  Future<String> fetchStats(String username) async {
    //We dont actually get anything here, because the JSON request doesnt contain the user. And i dont know how to add it.

    http.Request request = http.Request(
        "GET", Uri.parse('${SettingsController.address}/userScore'));
    request.body = jsonEncode(<String, String>{
      'User': username,
    });
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var response = await request.send();
    var thing = await response.stream.transform(utf8.decoder).first;

    //RESPONSE BURDE INDEHOLDE DATA'EN under "Score", but i dont know how to extract it

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.""
      //response[0];

      return thing;
      //fromJson(jsonDecode() as Map<String, dynamic>);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load form');
    }
  }

  Future<(List<String>, List<int>)> fetchCategories(String username) async {
    //We dont actually get anything here, because the JSON request doesnt contain the user. And i dont know how to add it.

    http.Request request = http.Request("GET",
        Uri.parse('${SettingsController.address}/carbonScoreCategories'));
    request.body = jsonEncode(<String, String>{
      'User': username,
    });
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var response = await request.send();

    var result = await response.stream.transform(utf8.decoder).first;
    var result2 = jsonDecode(result);
    
    Map<String, int> res = {
      "energyScore": result2['energyScore'],
      "foodScore": result2['foodScore'],
      "homeScore": result2['homeScore'],
      "otherScore": result2['otherScore'],
      "totalScore": result2['totalScore'],
      "transportScore": result2['transportScore'],
    };
    if (response.statusCode == 200) {
      print(res);
      return (res.keys.toList(), res.values.toList());
    } else {
      throw Exception('Failed to load average score');
    }
  }
}
