import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({
    super.key,
  });

  static const routeName = '/Settings';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: <Widget>[
              FormBuilderSwitch(name: 'darkmode', title: const Text('Darkmode'))
            ],
          ),
        ),
      ),
    );
  }
}
