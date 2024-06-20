import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';
import 'package:carbon_footprint/src/Dashboard/dashboard_controller.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

import 'dashboard_view.dart';

// written by Natascha and Gabriel
class CarbonScorePieChart extends StatefulWidget {
  const CarbonScorePieChart({super.key});

  @override
  State<CarbonScorePieChart> createState() => _CarbonScorePieChartState();
}

class _CarbonScorePieChartState extends State<CarbonScorePieChart> {
  final SettingsController _settingsController = SettingsController();

  final DashboardController _dashboardController = DashboardController();

// creates the segments of the piechart.
  List<Widget> addParts(List<Segment> segments, List<String> names) {
    List<Widget> res = [];

    for (int i = 0; i < segments.length; i++) {
      res = res +
          [
            Indicator(
              color: segments[i].color,
              text: names[i],
              isSquare: false,
              size: DashboardView.touchedIndex == i ? 35 : 35,
              textColor: DashboardView.touchedIndex == i
                  ? (_settingsController.themeMode == ThemeMode.dark
                      ? Colors.white
                      : Colors.black)
                  : Colors.grey,
            )
          ];
    }
    return res;
  }

  Future<(List<String>, List<int>)> toList() async {
    var res1 = Future(() async =>
        await _dashboardController.fetchCategories(UserController().username));

    return res1;
  }

//colors and writes names for the segments
  List<PieChartSectionData> showingSections(List<Segment> segments) {
    return List.generate(
      segments.length,
      (i) {
        final isTouched = i == DashboardView.touchedIndex;
        return PieChartSectionData(
          color: segments[i].color,
          value: segments[i].value.toDouble(),
          titleStyle: const TextStyle(
              color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
          title: (segments[i].value.toDouble() /
                      segments.fold(0, (sum, segment) => sum + segment.value) *
                      100)
                  .toStringAsFixed(1) +
              "%",
          radius: isTouched ? 110 : 80,
          titlePositionPercentageOffset: 0.55,
        );
      },
    );
  }

  //the main function.
  @override
  Widget build(BuildContext context) {
    var fut = toList();
    return FutureBuilder(
        future: fut,
        builder: (context, snapshot) {
          //placeholder data
          if (snapshot.hasData) {
            List<int> vals = [];
            List<String> names = [];
            //seperates the tuple into 2 lists, because its more readable.
            for (int i = 0; i < snapshot.data!.$1.length; i++) {
              vals = vals + [snapshot.data!.$2[i].toInt()];
              names = names + [snapshot.data!.$1[i]];
            }

            const List<String> labels = ["Transport", "Home", "Food", "Other"];
            List<Segment> segments = [
              //TODO: we need to change these index's to match waht we want
              Segment(
                  value: vals[0] + 1,
                  color: Colors.lightGreenAccent,
                  label: Text(names[0])),
              Segment(
                  value: vals[1],
                  color: Colors.orangeAccent,
                  label: Text(names[1])),
              Segment(
                  value: vals[2],
                  color: Colors.limeAccent,
                  label: Text(names[2])),
              Segment(
                  value: vals[3],
                  color: Colors.pinkAccent,
                  label: Text(names[3])),
              Segment(
                  value: vals[4], color: Colors.purple, label: Text(names[4])),
              //number 5 is totalscore, so we dont include that.
              //Segment(value: vals[5], color: Colors.pinkAccent, label: Text(names[5])),
            ];
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
              sections: showingSections(segments), // Optional
            ));
            return AspectRatio(
                aspectRatio: 1,
                child: ListView(children: <Widget>[
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
                          children: addParts(segments, names),
                        ),
                      ],
                    ),
                  )
                ]));
          } else if (snapshot.hasError) {
            if (kDebugMode) {
              print('Error: ${snapshot.error.toString()}');
            }
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Please navigate to Forms(3) to provide infomation to generate a dashboard')
              ],
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
