import 'dart:convert';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint/src/user_controller.dart';

// written by Gabriel and Natascha
class DashboardController {
  Future<List<dynamic>> getActions() async {
    http.Request request = http.Request(
        "GET", Uri.parse('${SettingsController.address}/actionTracker'));
    request.body = jsonEncode(<String, String>{
      'User': UserController().username,
    });
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    //ask server, and then decode from utf8 and json
    var response = await request.send();
    var items = await response.stream.transform(utf8.decoder).first;
    List<dynamic> res = jsonDecode(items);
    return res;
  }

  Future<List<double>> last7days() async {
    var baseDaily = UserController().carbonScore / 365;

    //print(res);
    List<dynamic> res = await getActions();

    var date = DateTime.now();
    List<double> list = [
      baseDaily,
      baseDaily,
      baseDaily,
      baseDaily,
      baseDaily,
      baseDaily,
      baseDaily
    ];

    //adds all elements from the last 7 days to the graph
    for (var i = 0; i < res.length; i++) {
      var diff = date.difference(DateTime.parse(res[i]['date']));
      if (diff.inDays < 7 && diff.inDays >= 0) {
        if ((diff.inDays == 0 && date.hour < diff.inHours)) {
          list[1] += res[i]['CarbonScore'];
        } else {
          list[diff.inDays] += res[i]['CarbonScore'];
        }
      }
    }
    //if any elements in the list are less than 0, set to 0 so we dont get negative carbon scores
    for (var i = 0; i < list.length; i++) {
      if (list[i] < 0) {
        list[i] = 0;
      }
    }
    return list;
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
      "transportScore": result2['transportScore'],
      "totalScore": result2['totalScore'],
    };
    if (response.statusCode == 200) {
      return (res.keys.toList(), res.values.toList());
    } else {
      throw Exception('Failed to load average score');
    }
  }
}
