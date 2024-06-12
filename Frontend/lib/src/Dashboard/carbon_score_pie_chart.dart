import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';
import 'package:carbon_footprint/src/Dashboard/dashboard_controller.dart';
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

import 'dashboard_view.dart';

class CarbonScorePieChart extends StatefulWidget {
  const CarbonScorePieChart({Key? key}) : super(key: key);

  @override
  State<CarbonScorePieChart> createState() => _CarbonScorePieChartState();

}

class _CarbonScorePieChartState extends State<CarbonScorePieChart> {
  SettingsController  _settingsController = SettingsController();

  DashboardController _dashboardController = DashboardController();

List<Widget> addParts(List<Segment> segments, List<String> names) {
    List<Widget> res = [];

    for (int i = 0; i < 5; i++) {
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

  Future<(List<String>, List<int>)> toMappp() async {

    var res1 = Future(() async =>
        await _dashboardController.fetchCategories(UserController().username));

    return res1;
  }

List<PieChartSectionData> showingSections(List<Segment> segments) {
    return List.generate(
      5,
      (i) {
        final isTouched = i == DashboardView.touchedIndex;
        Color color0 = segments[0].color;
        Color color1 = segments[1].color;
        Color color2 = segments[2].color;
        Color color3 = segments[3].color;
        Color color4 = segments[4].color;

        double? val0 = segments[0].value.toDouble();
        double? val1 = segments[1].value.toDouble();
        double? val2 = segments[2].value.toDouble();
        double? val3 = segments[3].value.toDouble();
        double? val4 = segments[4].value.toDouble();
        double? total = val0 + val1 + val2 + val3 + val4;

        String? title0 = "${(val0 / total * 100).toStringAsFixed(1)}%";
        String? title1 = "${(val1 / total * 100).toStringAsFixed(1)}%";
        String? title2 = "${(val2 / total * 100).toStringAsFixed(1)}%";
        String? title3 = "${(val3 / total * 100).toStringAsFixed(1)}%";
        String? title4 = "${(val4 / total * 100).toStringAsFixed(1)}%";
        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: val0,
              titleStyle: const TextStyle(
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
              titleStyle: const TextStyle(
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
              titleStyle: const TextStyle(
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
              titleStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              title: title3,
              radius: isTouched ? 110 : 80,
              titlePositionPercentageOffset: 0.55,
            );
          case 4:
            return PieChartSectionData(
              color: color4,
              value: val4,
              titleStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              title: title4,
              radius: isTouched ? 110 : 80,
              titlePositionPercentageOffset: 0.55,
            );
          default:
            throw Error();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var fut =
        toMappp();
    return FutureBuilder(
        future: fut,
        builder: (context, snapshot) {
          //placeholder data
          if (snapshot.hasData) {
            List<int> vals = [];
            List<String> names = [];
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
                
            child:  ListView(
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
                        children: addParts(segments, names),
                      ),
                    ],
                  ),
                )
              ]
            )
            );
          } else if (snapshot.hasError) {
            print('Error: ${snapshot.error.toString()}');
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Please navigate to Forms(3) to provide infomation to generate a dashboard')
              ],
            ));
              } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
}}