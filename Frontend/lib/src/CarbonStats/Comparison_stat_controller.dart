import 'dart:convert';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

// written by Gabriel
//
class CarbonStatController {
  Future<String> fetchAverage() async {
    // Fetch the average user's carbonscore
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
    // uses a list if ISO codes sent to the server to get the carbon score of the countries
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
    var resultBody = jsonDecode(result);
    Map<String, String> res = {};
    for (int i = 0; i < countries.length; i++) {
      res.addAll({
        resultBody[i]['Country'].toString():
            resultBody[i]['CarbonScore'].toString()
      });
    }
    if (response.statusCode == 200) {
      return (res.keys.toList(), res.values.toList());
    } else {
      throw Exception('Failed to load average score');
    }
  }
}
