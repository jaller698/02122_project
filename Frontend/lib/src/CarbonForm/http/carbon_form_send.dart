import 'dart:convert';

import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form_answer.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

Future<void> sendCarbonForm(CarbonFormAnswer answer) async {
  final response = await http.post(
    Uri.parse('${SettingsController.address}/questions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(CarbonFormAnswer.toJson(answer)),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return;
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create form.' + response.statusCode.toString());
  }
}
