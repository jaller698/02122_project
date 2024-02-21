import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_fetch.dart';
import 'package:flutter/material.dart';

import 'dart:io' show Platform;

class CarbonFormView extends StatefulWidget {
  const CarbonFormView({
    super.key,
  });

  @override
  State<CarbonFormView> createState() => _CarbonFormViewState();
}

class _CarbonFormViewState extends State<CarbonFormView> {
  late Future<CarbonForm> futureCarbonForm;

  @override
  void initState() {
    super.initState();
    futureCarbonForm = fetchCarbonForm();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<CarbonForm>(
        future: futureCarbonForm,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class CarbonFormDialog extends StatelessWidget {
  CarbonFormDialog({
    super.key,
    required fullscreen,
    required carbonForm,
  }) :  _fullscreen = fullscreen,
        _carbonForm = carbonForm;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool _fullscreen;

  final CarbonForm _carbonForm;

  @override
  Widget build(BuildContext context) {
    return [
      Dialog(child: _form(),), 
      Dialog.fullscreen(child: _form(),),
    ][(Platform.isIOS || Platform.isAndroid) ? 1 : 0];
  }

  Widget _form() {
    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: _carbonForm.questions.length, 
        itemBuilder: (BuildContext context, int index) {
          return TextFormField(
              decoration: InputDecoration(
                labelText: _carbonForm.questions.elementAt(index).title,
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