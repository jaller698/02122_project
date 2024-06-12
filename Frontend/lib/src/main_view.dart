import 'package:carbon_footprint/src/Settings/settings_view.dart';
import 'package:flutter/material.dart';

import 'CarbonForm/carbon_form_view.dart';
import 'CarbonTracker/carbon_tracker_view.dart';
import 'Dashboard/dashboard_view.dart';
import 'CarbonStats/carbon_stat_view.dart';
import 'Widgets/future_badge_icon_widget.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const routeName = '/home';

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPageIndex != 0
          ? AppBar(
              title: Text(
                [
                  'Dashboard',
                  'Carbon Tracker',
                  'Questionaires',
                  'Carbon Stats',
                ][_currentPageIndex],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.restorablePushNamed(
                      context, SettingsView.routeName),
                  icon: const Icon(
                    Icons.settings_rounded,
                  ),
                ),
              ],
            )
          : null,
      // list of widgets to switch between depending on the current page index
      body: <Widget>[
        const DashboardView(),
        CarbonTrackerView(),
        const CarbonFormView(),
        const CarbonStatView(),
      ][_currentPageIndex],

      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_alt),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: FutureBadgeIconWidget(),
            label: 'Forms',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard),
            label: 'Stats',
          ),
        ],
        onDestinationSelected: (int index) =>
            setState(() => _currentPageIndex = index),
        selectedIndex: _currentPageIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}
