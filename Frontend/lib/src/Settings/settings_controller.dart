import 'package:carbon_footprint/src/Settings/settings_service.dart';
import 'package:flutter/material.dart';

import 'package:carbon_footprint/src/user_controller.dart';

// written by Martin,
// controller to handles settings logic
class SettingsController with ChangeNotifier {
  // singleton
  SettingsController._hiddenConstructor();
  static final SettingsController _singleton =
      SettingsController._hiddenConstructor();
  factory SettingsController() => _singleton;

  static final SettingsService _settingsService = SettingsService();

  static const String address = 'https://gcx8clkd-9999.euw.devtunnels.ms';

  late ThemeMode _themeMode = ThemeMode.system;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadSettings() async {
    _themeMode = await _settingsService.themeMode();

    // update app
    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode? newThemeMode) async {
    if (newThemeMode == null) return;
    if (newThemeMode == _themeMode) return;

    _themeMode = newThemeMode;

    // update app
    notifyListeners();
    await _settingsService.updateThemeMode(newThemeMode);
  }

  Future<void> logout() async {
    //this likely isnt enough, but hey lets see :)
    UserController().username = "";
  }
}
