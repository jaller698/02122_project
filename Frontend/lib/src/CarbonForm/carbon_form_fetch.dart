import 'dart:convert';

import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:http/http.dart' as http;

Future<CarbonForm> fetchCarbonForm() async {
  final response = await http
      .get(Uri.parse('localhost:8080'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CarbonForm.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load form');
  }
}