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

  Future<(List<String>, List<int>)> toMappp() async {
    print("HEEEEEEEEY NOTICE ME");

    var res1 = Future(() async =>
        await _dashboardController.fetchCategories(UserController().username));

    print("notice me 2");
    print(res1);
    return res1;
  }

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

  @override
  Widget build(BuildContext context) {
    var fut =
        toMappp(); //Future(() async => await _dashboardController.fetchCategories(UserController().username));
    print("hej");
    return FutureBuilder(
        future: fut,
        builder: (context, snapshot) {
          //placeholder data
          /* const List<String> labels = ["Transport", "Home", "Food", "Other"];
                List<Segment> segments = [
              Segment(value: 37, color: Colors.lightGreenAccent, label: Text(labels[0])),
              Segment(value: 20, color: Colors.orangeAccent, label: Text(labels[1])),
              Segment(value: 18, color: Colors.limeAccent, label: Text(labels[2])),
              Segment(value: 33, color: Colors.pinkAccent, label: Text(labels[3])),
            ];*/
          //print(snapshot.hasData);
          print("vals1");
          if (snapshot.hasData) {
            print("vals2");

            List<int> vals = [];
            List<String> names = [];
            for (int i = 0; i < snapshot.data!.$1.length; i++) {
              vals = vals + [snapshot.data!.$2[i].toInt()];
              names = names + [snapshot.data!.$1[i]];
            }
            print("energyscore:");
            //print("vals");
            //
            //print(snapshot.data!.$2[0]);

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
                        children: addParts(segments, names),
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
          } else if (snapshot.hasError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Please navigate to Forms(3) to provide infomation to generate a dashboard'),
                Text('Error: ${snapshot.error.toString()}'),
              ],
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
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
}
