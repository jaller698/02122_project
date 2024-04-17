import 'package:carbon_footprint/src/CarbonForm/Widgets/carbon_form_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'CarbonForm/carbon_form_view.dart';
import 'CarbonTracker/carbon_tracker_view.dart';
import 'Dashboard/dashboard_view.dart';
import 'CarbonStats/Carbon_stat_view.dart';

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
      // list of widgets to switch between depending on the current page index
      body: <Widget>[
        const DashboardView(),
        CarbonTrackerView(),
        const CarbonFormView(),
        const CarbonStatView(),
        const Placeholder(
            child: Center(child: Card(child: Text('Column BARS, todo')))),
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
            icon: Badge(child: Icon(Icons.list_alt)),
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