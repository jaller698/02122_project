import 'dart:math';

import 'package:carbon_footprint/src/Dashboard/carbon_score_pie_chart.dart';
import 'package:carbon_footprint/src/Dashboard/carbon_score_widget.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:flutter/material.dart';

import 'week_summary_bar_chart.dart';

// written by Martin, // TODO - somebody else was here
// stateless part of stateful widget, contains route name
class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
  });

  static int touchedIndex = -1;
  //static ThemeMode tm = _settingsService.themeMode() as ThemeMode;
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

// written by Martin, Christian
// a dashboard which contains widgets that contextualize the users actions from different sources along with fun facts
class _DashboardViewState extends State<DashboardView> {
  get_random_tips() {
    // return a random tip, currently hardcoded but could be fetched from a file or database
    var random_facts = [
      "Carbon dioxide consists of one carbon atom and two oxygen atoms, making its chemical formula CO2.",
      "CO2 is what gives soda and sparkling water their fizz.",
      "CO2 is used in fire extinguishers because it can suffocate flames by displacing oxygen",
      "CO2 is often added to greenhouses to enhance plant growth.",
      "CO2 is a major greenhouse gas, trapping heat in the atmosphere and contributing to global warming.",
      "CO2 dissolves in seawater, forming carbonic acid, which lowers the pH of oceans and affects marine life."
    ];
    return random_facts[Random().nextInt(random_facts.length)];
  }

  // Build the dashboard view, containing the carbon score, a pie chart, a bar chart and a random fact
  // most functionality is handled by the widgets themselves, to give clean code here.
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
        Row(children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  get_random_tips(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ]),
      ],
    );
  }
}
