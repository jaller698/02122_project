import 'package:carbon_footprint/src/CarbonForm/carbon_form_view.dart';
import 'package:carbon_footprint/src/Views/main_view.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      restorationScopeId: 'app',

      // TODO implement settings controller for themes
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,

      title: 'Carbon footprint',
      onGenerateRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) {
            switch (routeSettings.name) {
              case CarbonFormView.routeName:
                return CarbonFormView(carbonForm: routeSettings.arguments);
              case MainView.routeName:
              default:
                return const MainView();
            }
          },
        );
      },
    );
  }
}
