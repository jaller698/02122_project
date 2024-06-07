import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';

import 'carbon_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';

class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});

  static const routeName = '/carbonstats';

  static final CarbonStatController _carbonController = CarbonStatController();

  Future<List<String>> toList(String Comp) async {
    Future<List<String>> fut = Future(() async =>
        [
          await _carbonController.fetchStats(UserController().username),
          await _carbonController.fetchAverage()
        ] +
        [(await _carbonController.fetchCountries())]);
    return fut;
  }

  @override
  Widget build(BuildContext context) {
    //  _carbonController.readStats().then(((value) {
    //     k = value.toString();
    //   }));
    //FIgure out how to go from Future<double> to String.
//(_carbonController.fetchStats(UserController().username)).toString()
    var fut = toList("guest");
    const double width = 7;

    late List<BarChartGroupData> rawBarGroups;
    late List<BarChartGroupData> showingBarGroups;

    // Make the names dynamic, except the first 2.
    //also this has to wait until the return types for the countries are made into maps.
    const colorIndicators = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Indicator(
            color: Colors.red,
            text: "User   ",
            isSquare: true,
            size: 40,
            textColor: Colors.black,
          ),
          Indicator(
              color: Colors.blue,
              text: "Average   ",
              isSquare: true,
              size: 40,
              textColor: Colors.black),
          Indicator(
              color: Colors.purple,
              text: "Denmark   ",
              isSquare: true,
              size: 40,
              textColor: Colors.black)
        ]);

    return FutureBuilder(
      future: fut,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<double> vals = [];
          for (int i = 0; i < snapshot.data!.length; i++) {
            vals = vals + [double.parse(snapshot.data![i])];
          }
          //there is 100% a better way to do this, however i cannot be bothered to figure out how to apply something to an entire list in dart.
          final barchart1 = makeGroupData(0, vals);
          final items = [
            barchart1
            /*
              insert more barcharts if needed.
              */
          ];
          rawBarGroups = items;
          final barChart = BarChart(BarChartData(
            maxY: 20,
            //barGroups: showingBarGroups,
            barGroups: List.of(rawBarGroups),
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: bottomTitles,
                  reservedSize: 42,
                ),
              ),
            ),
            //swapAnimationDuration: Duration(milliseconds: 150), // Optional
            //swapAnimationCurve: Curves.linear, // Optional
          ));
          return ListView(children: <Widget>[
            Container(
              height: 600,
              child: barChart,
            ),
            colorIndicators
          ]);
        } else if (snapshot.hasError) {
          return Center(child: Text('error: ${snapshot.error.toString()}'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/* 
// this is now legacy code, but keep it in case we need to figure something out.
BarChartGroupData makeGroupData(int x, double y1, double y2) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: [
      BarChartRodData(
        toY: y1,
        color: Colors.blue,
        width: 10,
      ),
      BarChartRodData(
        toY: y2,
        color: Colors.red,
        width: 10,
      ),
    ],
  );
}
*/
BarChartGroupData makeGroupData(int x, List<double> y) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: createBarchart(y),
  );
}

List<BarChartRodData> createBarchart(List<double> y) {
  List<BarChartRodData> res = [];
  List<Color> col = [
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.orange
  ];
  for (int i = 0; i < y.length; i++) {
    res = res +
        [
          BarChartRodData(
            toY: y[i],
            color: col[i],
            width: 10,
          )
        ];
  }
  return res;
}

Widget bottomTitles(double value, TitleMeta meta) {
  final titles = <String>['Carbon score'];

  final Widget text = Text(
    titles[value.toInt()],
    style: const TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    ),
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 16, //margin top
    child: text,
  );
}
