import 'dart:convert';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:crypto/crypto.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:http/http.dart' as http;

// written by Martin, Christian
// request to log in a user with given credentials
Future<bool> getUserSession(String username, String password) async {
  http.Request request =
      http.Request("GET", Uri.parse('${SettingsController.address}/users'));

  var _hashedPassword = sha256.convert(utf8.encode(password));
  request.body = jsonEncode(<String, String>{
    'User': username,
    'Password': _hashedPassword.toString()
  });
  request.headers.addAll(<String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });

  var response = await request.send();

  if (response.statusCode == 200) {
    var responseBody = const JsonDecoder()
        .convert(await response.stream.transform(utf8.decoder).first);
    UserController().username = username;
    UserController().carbonScore = responseBody['Score'];
    return true;
  } else if (response.statusCode == 401) {
    return false;
  } else {
    throw Exception('Failed to login user.');
  }
}
