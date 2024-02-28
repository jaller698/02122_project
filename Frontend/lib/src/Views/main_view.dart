import 'package:carbon_footprint/src/CarbonForm/Widgets/carbon_form_button.dart';
import 'package:carbon_footprint/src/modals/delete_data.dart';
import 'package:carbon_footprint/src/modals/fetch_data.dart';
import 'package:carbon_footprint/src/modals/send_data.dart';
import 'package:carbon_footprint/src/modals/update_data.dart';
import 'package:carbon_footprint/src/modals/websocket.dart';
import 'package:flutter/material.dart';

import '../CarbonForm/carbon_form_view.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  static const routeName = '/';

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
        const FetchData(),
        const Center(child: CarbonFormButton()),
      ][_currentPageIndex],

      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.leak_add),
            label: 'FetchData',
          ),
          /*NavigationDestination(
            icon: Icon(Icons.send),
            label: 'SendData',
          ),
          NavigationDestination(
            icon: Icon(Icons.update),
            label: 'UpdateData',
          ),
          NavigationDestination(
            icon: Icon(Icons.delete),
            label: 'DeleteData',
          ),
          NavigationDestination(
            icon: Icon(Icons.link),
            label: 'WebSocket',
          ),*/
          NavigationDestination(
            icon: Icon(Icons.list_alt), 
            label: 'form',
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
