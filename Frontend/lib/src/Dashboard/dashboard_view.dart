import 'package:carbon_footprint/src/Dashboard/carbon_score_pie_chart.dart';
import 'package:carbon_footprint/src/Dashboard/carbon_score_widget.dart';
import 'package:flutter/material.dart';

import 'week_summary_bar_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
  });

  static int touchedIndex = -1;
  //static ThemeMode tm = _settingsService.themeMode() as ThemeMode;
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const CarbonScoreWidget(carbonScore: 200),
        const Divider(),
        const CarbonScorePieChart(),
        const Divider(),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: WeekSummaryBarChart(),
            ),
            const Expanded(
              flex: 1,
              child: Card(
                child: Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Tips',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const Divider(),
        const Row(
          children: [
            Expanded(
              flex: 1,
              child: Placeholder(
                fallbackHeight: 150,
                child: Text('tips og reminders til at forminske ens forbrug'),
              ),
            ),
            Expanded(
              flex: 2,
              child: Placeholder(
                fallbackHeight: 150,
                child:
                    Text('Hvis alle gjorde som dig, hvordan vil jorden se ud?'),
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
