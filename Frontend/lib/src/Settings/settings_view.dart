import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../LoginPage/login_view.dart';

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

  final SettingsController _settingsController = SettingsController();

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
              FormBuilderSwitch(
                name: 'darkmode',
                title: const Text('Darkmode'),
                initialValue: _settingsController.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  if (value == null) return;

                  value
                      ? _settingsController.updateThemeMode(ThemeMode.dark)
                      : _settingsController.updateThemeMode(ThemeMode.light);
                },
              ),
              OutlinedButton(
                    onPressed: () {
                      _settingsController.logout();
                      Navigator.popAndPushNamed(context, LoginView.routeName);
                    },
                    child: const Text('Sign Out')
              ),
              

            ],
          ),
        ),
      ),
    );
  }
}
