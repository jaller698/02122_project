import 'dart:convert';

import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

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

  Future<double> readStats() async {
    //kinda like a placeholder
    return 4.1;
  }

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
    var thing= await response.stream.transform(utf8.decoder).first;


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
}
