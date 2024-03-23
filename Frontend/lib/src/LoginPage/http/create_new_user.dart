import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

Future<bool> createNewUser(String username, String password) async {
  var _hashedPassword = sha256.convert(utf8.encode(password));
  final response = await http.post(
    Uri.parse('${SettingsController.address}/users'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'User': username,
      'Password': _hashedPassword.toString(),
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else if (response.statusCode == 401) {
    // todo
    return false;
  } else {
    throw Exception('Failed to create user.');
  }
}
