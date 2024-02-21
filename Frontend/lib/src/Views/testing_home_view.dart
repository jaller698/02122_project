import 'package:carbon_footprint/src/modals/delete_data.dart';
import 'package:carbon_footprint/src/modals/fetch_data.dart';
import 'package:carbon_footprint/src/modals/send_data.dart';
import 'package:carbon_footprint/src/modals/update_data.dart';
import 'package:carbon_footprint/src/modals/websocket.dart';
import 'package:flutter/material.dart';

class TestingHomeView extends StatefulWidget {
  const TestingHomeView({super.key});
  static const routeName = '/';

  @override
  State<TestingHomeView> createState() => _TestingHomeViewState();
}

class _TestingHomeViewState extends State<TestingHomeView> {
  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // list of widgets to switch between depending on the current page index
      body: <Widget>[
        const FetchData(),
        const SendData(),
        const UpdateData(),
        const DeleteData(),
        const WebSocket(),
      ][_currentPageIndex],

      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.leak_add),
            label: 'FetchData',
          ),
          NavigationDestination(
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
