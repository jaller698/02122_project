import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:flutter/material.dart';

import 'src/app.dart';

void main() async {
  final settingsController = SettingsController();
  WidgetsFlutterBinding.ensureInitialized();

  await settingsController.loadSettings();
  runApp(const MyApp());
}
