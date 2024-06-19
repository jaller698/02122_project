import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// written by Martin,
// service to settings controller to save and retrive the users preferred states for various settings
class SettingsService {
  Future<ThemeMode> themeMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return ThemeMode.values
        .byName(prefs.getString('themeMode') ?? ThemeMode.system.name);
  }

  Future<void> updateThemeMode(ThemeMode theme) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('themeMode', theme.name);
  }
}
