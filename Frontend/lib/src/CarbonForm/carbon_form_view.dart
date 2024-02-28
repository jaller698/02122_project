import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_fetch.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;

import 'Widgets/carbon_form_button.dart';

class CarbonFormView extends StatefulWidget {
  const CarbonFormView({
    super.key,
    required carbonForm
  }) : _carbonForm = carbonForm;

  static const routeName = '/Carbon_Form';

  final CarbonForm _carbonForm;

  @override
  State<CarbonFormView> createState() => _CarbonFormViewState();
}

class _CarbonFormViewState extends State<CarbonFormView> {
  late Future<CarbonForm> futureCarbonForm;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: widget._carbonForm.questions.length, 
        itemBuilder: (BuildContext context, int index) {
          return TextFormField(
              decoration: InputDecoration(
                labelText: widget._carbonForm.questions.elementAt(index).title,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                return null;
              },
          ); 
        },
      ),
    );
  }
}