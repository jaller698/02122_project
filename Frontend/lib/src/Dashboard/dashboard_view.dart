import 'package:carbon_footprint/src/Dashboard/carbon_score_pie_chart.dart';
import 'package:carbon_footprint/src/Dashboard/carbon_score_widget.dart';
import 'package:carbon_footprint/src/user_controller.dart';
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
        CarbonScoreWidget(carbonScore: UserController().carbonScore),
        const Divider(),
        const CarbonScorePieChart(),
        const Divider(),
        Expanded(
          flex: 2,
          child: WeekSummaryBarChart(),
        ),
        const Divider(),
        const Row(children: [
          Expanded(
            flex: 1,
            child: Placeholder(
              fallbackHeight: 150,
              child: Text('tips og reminders til at forminske ens forbrug'),
            ),
          ),
        ]),
      ],
    );
  }
}
