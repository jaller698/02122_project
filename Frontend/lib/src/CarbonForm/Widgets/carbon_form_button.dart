import 'dart:ffi';

import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_view.dart';
import 'package:flutter/material.dart';

import '../carbon_form_fetch.dart';

class CarbonFormButton extends StatefulWidget {
  const CarbonFormButton({
    super.key,
  });

  @override
  State<CarbonFormButton> createState() => _CarbonFormButtonState();
}

class _CarbonFormButtonState extends State<CarbonFormButton> {
  bool awatingData = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: [
      ElevatedButton(
        onPressed: () {
          // request form data from server
          Future<CarbonForm> futureCarbonForm = fetchCarbonForm();
          setState(() => awatingData = true);

          // give feedback to user
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("requesting form...")));

          futureCarbonForm.then((value) {
            setState(() => awatingData = false);

            Navigator.restorablePushNamed(context, CarbonFormView.routeName, arguments: value);

          }).catchError((error) {
            setState(() => awatingData = false);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ERROR: $error")));

          });
        },
        child: const Text("request form"),
      ),
      const CircularProgressIndicator.adaptive(),
      ][awatingData ? 1 : 0]
    );
  }
}
