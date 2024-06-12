import 'package:carbon_footprint/src/Dashboard/carbon_score_pie_chart.dart';
import 'package:carbon_footprint/src/Dashboard/carbon_score_widget.dart';
import 'package:carbon_footprint/src/Dashboard/dashboard_controller.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';
import 'package:carbon_footprint/src/user_controller.dart';

import 'week_summary_bar_chart.dart';
import 'dashboard_controller.dart';

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
  static final DashboardController _dashboardController = DashboardController();

  final SettingsController _settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
                const CarbonScoreWidget(carbonScore: 200),
                const Divider(),
                const CarbonScorePieChart(),
                const Divider(),
                    Expanded(
                      flex: 2,
                      child: WeekSummaryBarChart(),
                    ),
                const Divider(),
                const Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Placeholder(
                        fallbackHeight: 150,
                        child: Text(
                            'tips og reminders til at forminske ens forbrug'),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Placeholder(
                        fallbackHeight: 150,
                        child: Text(
                            'Hvis alle gjorde som dig, hvordan vil jorden se ud?'),
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
