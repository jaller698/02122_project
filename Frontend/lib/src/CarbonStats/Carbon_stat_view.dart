
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';
import 'dart:math';
import 'Carbon_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';

class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});

  static const routeName = '/carbonstats';

  static final CarbonStatController _carbonController = CarbonStatController();

  Future<(List<String>, List<String>)> toList() async {
    var res = (await _carbonController.fetchCountries());
    Future<(List<String>, List<String>)> fut2 = Future(() async => (
              [
                await _carbonController.fetchStats(UserController().username),
                await _carbonController.fetchAverage()
              ] +
              res.$2,
          ["User", "Avr"] + res.$1
        ));
    return (fut2);
  }

  @override
  Widget build(BuildContext context) {
    //  _carbonController.readStats().then(((value) {
    //     k = value.toString();
    //   }));
    //FIgure out how to go from Future<double> to String.
//(_carbonController.fetchStats(UserController().username)).toString()
    var fut = toList();

    const double width = 7;

    late List<BarChartGroupData> rawBarGroups;
    late List<BarChartGroupData> showingBarGroups;

    // Make the names dynamic, except the first 2.
    //also this has to wait until the return types for the countries are made into maps.

    return FutureBuilder(
      future: fut,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          //this list controls what colors we use
          //it also limits how many things we can show, since we must never run out of colors.
          List<Color> col = [
            Colors.red,
            Colors.blue,
            Colors.purple,
            Colors.pink,
            Colors.orange
          ];

          List<double> vals = [];
          List<String> names = [];
          for (int i = 0; i < snapshot.data!.$1.length && i < col.length; i++) {
            vals = vals + [double.parse(snapshot.data!.$1[i])];
            names = names + [snapshot.data!.$2[i]];
          }

          //////// outline for when assignment of names starts
          Row colorIndicators = Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: createNames(names, col));
          ///////////////// doing this just to outline when this ends

          //there is 100% a better way to do this, however i cannot be bothered to figure out how to apply something to an entire list in dart.
          final barchart1 = makeGroupData(0, vals, col);
          final items = [
            barchart1
            /*
              insert more barcharts if needed.
              */
          ];
          rawBarGroups = items;
          final barChart = BarChart(BarChartData(
            maxY: vals.reduce(max)+100,
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

List<Widget> createNames(List<String> names, List<Color> col) {
  List<Widget> res = [];
  for (int i = 0; i < names.length; i++) {
    res = res +
        [
          Indicator(
            color: col[i],
            text: "${names[i]}   ",
            isSquare: true,
            size: 40,
            textColor: Colors.black,
          )
        ];
  }
  return res;
}


BarChartGroupData makeGroupData(int x, List<double> y, List<Color> col) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: createBarchart(y, col),
  );
}

List<BarChartRodData> createBarchart(List<double> y, List<Color> col) {
  List<BarChartRodData> res = [];
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
