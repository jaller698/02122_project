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
        const NetworkMessageView(),
        const Stack(children: [
          Placeholder(),
          Center(child: Text('page 2')),
        ]),
      ][_currentPageIndex],

      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.leak_add),
            label: 'page 1',
          ),
          NavigationDestination(
            icon: Icon(Icons.tune),
            label: 'page 2',
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

class NetworkMessageView extends StatelessWidget {
  const NetworkMessageView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Stack(children: [
      Placeholder(),
      Center(child: Text('page 1')),
    ]);
  }
}
