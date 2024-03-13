import 'dart:convert';

import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

Future<bool> getUserSession(String username, String password) async {
  final response = await http.post(
    Uri.parse('${SettingsController.address}/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{'User': username, 'Password': password}),
  );

  if (response.statusCode == 200) {
    return true;
  } else if (response.statusCode == 401) {
    // todo
    return false;
  } else {
    throw Exception('Failed to login user.');
  }
}
