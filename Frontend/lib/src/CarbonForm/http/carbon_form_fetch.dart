import 'dart:convert';

import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

// written by Martin,
// http get request to get the latest carbon form or questionnaire
Future<CarbonForm> fetchCarbonForm() async {
  // the future http response to the request
  final response =
      await http.get(Uri.parse('${SettingsController.address}/questions'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CarbonForm.fromMap(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load form');
  }
}
