import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';

import 'week_summary_bar_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({
    super.key,
  });
  static const List<String> labels = ["Transport", "Home", "Food", "Other"];
  static List<Segment> segments = [
    Segment(value: 34, color: Colors.lightGreenAccent, label: Text(labels[0])),
    Segment(value: 20, color: Colors.orangeAccent, label: Text(labels[1])),
    Segment(value: 18, color: Colors.limeAccent, label: Text(labels[2])),
    Segment(value: 33, color: Colors.pinkAccent, label: Text(labels[3])),
  ];
  static int touchedIndex = -1;
  //static ThemeMode tm = _settingsService.themeMode() as ThemeMode;
  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final SettingsController _settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    final pieChart = PieChart(PieChartData(
      pieTouchData: PieTouchData(
        touchCallback: (FlTouchEvent event, pieTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                pieTouchResponse == null ||
                pieTouchResponse.touchedSection == null) {
              DashboardView.touchedIndex = -1;
              return;
            }
            DashboardView.touchedIndex =
                pieTouchResponse.touchedSection!.touchedSectionIndex;
          });
        },
      ),

      startDegreeOffset: 180,
      borderData: FlBorderData(
        show: false,
      ),

      sectionsSpace: 1,
      centerSpaceRadius: 40,
      sections: showingSections(), // Optional
    ));
    return ListView(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 0.5,
                  child: pieChart,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Indicator(
                    color: DashboardView.segments[0].color,
                    text: DashboardView.labels[0],
                    isSquare: false,
                    size: DashboardView.touchedIndex == 0 ? 40 : 40,
                    textColor: DashboardView.touchedIndex == 0
                        ? (_settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)
                        : Colors.grey,
                  ),
                  Indicator(
                    color: DashboardView.segments[1].color,
                    text: DashboardView.labels[1],
                    isSquare: false,
                    size: DashboardView.touchedIndex == 1 ? 40 : 40,
                    textColor: DashboardView.touchedIndex == 1
                        ? (_settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)
                        : Colors.grey,
                  ),
                  Indicator(
                    color: DashboardView.segments[2].color,
                    text: DashboardView.labels[2],
                    isSquare: false,
                    size: DashboardView.touchedIndex == 2 ? 40 : 40,
                    textColor: DashboardView.touchedIndex == 2
                        ? (_settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)
                        : Colors.grey,
                  ),
                  Indicator(
                    color: DashboardView.segments[3].color,
                    text: DashboardView.labels[3],
                    isSquare: false,
                    size: DashboardView.touchedIndex == 3 ? 40 : 40,
                    textColor: DashboardView.touchedIndex == 3
                        ? (_settingsController.themeMode == ThemeMode.dark
                            ? Colors.white
                            : Colors.black)
                        : Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
        /*Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: progressBar,
          ),
        ),*/
        const Divider(),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: WeekSummaryBarChart(),
            ),
            const Expanded(
              flex: 1,
              child: Placeholder(
                child: Text('TIPS'),
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

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
      (i) {
        final isTouched = i == DashboardView.touchedIndex;
        Color color0 = DashboardView.segments[0].color;
        Color color1 = DashboardView.segments[1].color;
        Color color2 = DashboardView.segments[2].color;
        Color color3 = DashboardView.segments[3].color;

        double? val0 = DashboardView.segments[0].value.toDouble();
        double? val1 = DashboardView.segments[1].value.toDouble();
        double? val2 = DashboardView.segments[2].value.toDouble();
        double? val3 = DashboardView.segments[3].value.toDouble();
        double? total = val0 + val1 + val2 + val3;

        String? title0 = (val0 / total * 100).toStringAsFixed(1) + "%";
        String? title1 = (val1 / total * 100).toStringAsFixed(1) + "%";
        String? title2 = (val2 / total * 100).toStringAsFixed(1) + "%";
        String? title3 = (val3 / total * 100).toStringAsFixed(1) + "%";
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: val0,
              titleStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              title: title0,
              radius: isTouched ? 110 : 80,
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: val1,
              titleStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              title: title1,
              radius: isTouched ? 110 : 80,
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: val2,
              titleStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              title: title2,
              radius: isTouched ? 110 : 80,
              titlePositionPercentageOffset: 0.55,
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: val3,
              titleStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              title: title3,
              radius: isTouched ? 110 : 80,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }
}
