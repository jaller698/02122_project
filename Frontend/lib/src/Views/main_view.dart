import 'package:carbon_footprint/src/CarbonForm/Widgets/carbon_form_button.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../CarbonTracker/carbon_tracker_view.dart';
import '../Dashboard/dashboard_view.dart';

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
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          double xPos = details.delta.dx;

          print(xPos);

          // swipe right
          if (xPos > 0) {
            setState(() => _currentPageIndex++);
          }

          // swipe left
          if (xPos < 0) {
            setState(() => _currentPageIndex--);
          }
        },
        child: <Widget>[
          const DashboardView(),
          const CarbonTrackerView(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CarbonFormButton(),
              FilledButton(
                child: const Text('settings'),
                onPressed: () => showLicensePage(context: context),
              )
            ],
          ),
          const Placeholder(
              child: Center(child: Card(child: Text('Column BARS, todo')))),
        ][_currentPageIndex],
      ),

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
