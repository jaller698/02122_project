import 'dart:convert';
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
   Future<(List<String>,List<String>)> fetchCountries() async {
    http.Request request =
        http.Request("GET", Uri.parse('${SettingsController.address}/comparison'));
        //gotta make this dynamic.
    var countries = ["DNK", "SWE"];

      request.body = jsonEncode(<String, List<String>>{
      'landcodes': countries,
    });

    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    var response = await request.send();
    
    var result = await response.stream.transform(utf8.decoder).first;
    var result2 =  jsonDecode(result);
    print(result2[0]['CarbonScore']);
    Map<String, String> res = {};
    for (int i=0; i<countries.length; i++){
      res.addAll({result2[i]['Country'].toString(): result2[i]['CarbonScore'].toString()});
    }
    print(res.values.toList());
    if (response.statusCode == 200) {
      print(result + " Youre a little bit just like me");

      return (res.keys.toList(),res.values.toList());
    } else {
      throw Exception('Failed to load average score');
    }
  }
}
