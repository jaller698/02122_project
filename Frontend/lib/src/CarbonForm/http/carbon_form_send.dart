import 'dart:convert';

import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form_answer.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_history_controller.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:http/http.dart' as http;

// written by Martin
// http post request to submit a completed carbon form or questionnaire
Future<void> sendCarbonForm(CarbonFormAnswer answer) async {
  // the future http response to the request
  final response = await http.post(
    Uri.parse('${SettingsController.address}/questions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(CarbonFormAnswer.toMap(answer)),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then saves the form in history
    CarbonFormHistoryController().addForm(answer);
    var responseBody = const JsonDecoder().convert(response.body);
    UserController().carbonScore = responseBody['response']['carbonScore'];
    return;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to send form. Code: ${response.statusCode}');
  }
}
