import 'package:carbon_footprint/src/Settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({
    super.key,
  });

  static List<Segment> segments = [
    const Segment(value: 29, color: Colors.purple, label: Text("Transport")),
    const Segment(value: 20, color: Colors.deepOrange, label: Text("Home")),
    const Segment(value: 18, color: Colors.lime, label: Text("Food")),
    const Segment(value: 33, color: Colors.green, label: Text("Other")),
  ];

  @override
  Widget build(BuildContext context) {
    final progressBar = PrimerProgressBar(segments: segments);

    return ListView(
      children: <Widget>[
        const Placeholder(
          fallbackHeight: 400,
          child: Center(
            child: Card(
              child: Text(
                  'Half circle with ones own carbon emission seperated by catagory'),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: progressBar,
          ),
        ),
        const Divider(),
        Row(
          children: [
            const Expanded(
              flex: 2,
              child: Placeholder(
                fallbackHeight: 150,
              ),
            ),
            Expanded(
              flex: 1,
              child: Card.outlined(
                child: InkWell(
                  child: const SizedBox(
                    height: 150,
                    child: Icon(
                      Icons.settings_rounded,
                      size: 125,
                    ),
                  ),
                  onTapUp: (_) => Navigator.restorablePushNamed(
                      context, SettingsView.routeName),
                ),
              ),
            ),
          ],
        ),
        const Row(
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
        const Divider(),
        const Placeholder(
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
