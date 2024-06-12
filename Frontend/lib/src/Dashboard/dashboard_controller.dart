import 'dart:convert';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint/src/user_controller.dart';

// written by // TODO
class DashboardController {
  Future<List<double>> last7days() async {
    print("last7days has been called");
    //var items = await carbonTrackerItems;
    http.Request request = http.Request(
        "GET", Uri.parse('${SettingsController.address}/actionTracker'));
    request.body = jsonEncode(<String, String>{
      'User': UserController().username,
    });
    request.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    http.Request request2 = http.Request(
        "GET", Uri.parse('${SettingsController.address}/userScore'));
    request2.body = jsonEncode(<String, String>{
      'User': UserController().username,
    });
    request2.headers.addAll(<String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });

    var response = await request.send();
    print("2nd thing work");
    var items = await response.stream.transform(utf8.decoder).first;
    //print(items);
    var res = jsonDecode(items);
    print(res);

    var response2 = await request2.send();
    var baseYearly = await response2.stream.transform(utf8.decoder).first;
    var baseDaily = double.parse(baseYearly) / 365;
    //print("BaseYearly/actual carbonscore:");
    //print(baseYearly);
    print("BaseDaily:");
    print(baseDaily);
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
    /*     for (var i = 0; i < res.length; i++) {
          print(res[i]);
          //list[diff.inDays] += items[i].carbonScore;
          list[i] += baseDaily-i*2;
        
    }
*/
    for (var i = 0; i < res.length; i++) {
      var diff = date.difference(DateTime.parse(res[i]['date']));
      print("days");
      print(diff.inDays);
      print(date.hour - diff.inHours);
      if (diff.inDays <= 7 && diff.inDays >= 0) {
        if ((diff.inDays == 0 && date.hour < diff.inHours)) {
          list[1] += res[i]['CarbonScore'];
        } else {
          list[diff.inDays] += res[i]['CarbonScore'];
        }
        //list[diff.inDays] += items[i].carbonScore;
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
