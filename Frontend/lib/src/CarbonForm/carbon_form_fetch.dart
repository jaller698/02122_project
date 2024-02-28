import 'dart:convert';

import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<CarbonForm> fetchCarbonForm() async {
  //return CarbonForm.fromJson(await jsonDecode(await rootBundle.loadString('assets/carbon_form.json')) as Map<String, dynamic>);

  final response = await http
      .get(Uri.parse('http://localhost:8080'))
      .timeout(const Duration(seconds: 5));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return CarbonForm.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load form');
  }
}
