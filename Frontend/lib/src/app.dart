import 'package:carbon_footprint/src/CarbonForm/carbon_form_questionnaire.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_view.dart';
import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_view.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:carbon_footprint/src/main_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'LoginPage/login_view.dart';
import 'Settings/settings_view.dart';

// written by Martin,
// route navigator to all views beyond the 4 base main view handles
// as root widget also handles changes which effect the entire app, such as a theme switch
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root widget
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsController(),
      builder: (context, child) {
        return MaterialApp(
          restorationScopeId: 'app',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: SettingsController().themeMode,
          title: 'Carbon footprint',
          onGenerateRoute: (RouteSettings routeSettings) {
            // root navigator
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                if (kIsWeb) {
                  // web page routes
                  switch (routeSettings.name) {
                    case CarbonFormQuestionnaire.routeName:
                      return CarbonFormQuestionnaire(
                          carbonForm: routeSettings.arguments);
                    case MainView.routeName:
                    default:
                      return const MainView();
                  }
                } else {
                  // app page routes
                  switch (routeSettings.name) {
                    case CarbonFormView.routeName:
                      return const CarbonFormView();
                    case CarbonFormQuestionnaire.routeName:
                      return CarbonFormQuestionnaire(
                          carbonForm: routeSettings.arguments);
                    case SettingsView.routeName:
                      return const SettingsView();
                    case MainView.routeName:
                      return const MainView();
                    case CarbonTrackerView.routeName:
                      return CarbonTrackerView();
                    default:
                      return const LoginView();
                  }
                }
              },
            );
          },
        );
      },
    );
  }
}
