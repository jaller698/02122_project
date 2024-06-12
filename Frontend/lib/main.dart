import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

// written by Flutter, required base function
// pre initialization functions, such as settings to ensure dark mode gets sets before the first frame
void main() async {
  final settingsController = SettingsController();
  WidgetsFlutterBinding.ensureInitialized();

  await settingsController.loadSettings();
  runApp(const MyApp());
}
