import 'dart:convert';

import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        Placeholder(
          fallbackHeight: 400,
          child: Center(
            child: Card(
              child: Text(
                  'Half circle with ones own carbon emission seperated by catagory'),
            ),
          ),
        ),
        Placeholder(
          fallbackHeight: 50,
          child: Center(
            child: Card(
              child: Text('Linear progressbar to personal emission goal'),
            ),
          ),
        ),
        Divider(),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Placeholder(
                fallbackHeight: 150,
              ),
            ),
            Expanded(
              flex: 1,
              child: Placeholder(
                fallbackHeight: 150,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Placeholder(
                fallbackHeight: 150,
              ),
            ),
            Expanded(
              flex: 2,
              child: Placeholder(
                fallbackHeight: 150,
              ),
            ),
          ],
        ),
        Divider(),
        Placeholder(
          fallbackHeight: 50,
          child: Center(
            child: Card(
              child: Text(' Jank central '),
            ),
          ),
        ),
      ],
    );
  }
}
