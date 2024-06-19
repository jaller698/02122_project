import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';
import 'dart:math';
import 'Comparison_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';

// written by Gabriel and Natascha

class ComparisonStatView extends StatelessWidget {
  const ComparisonStatView({super.key});

  static const routeName = '/carbonstats';

  static final CarbonStatController _carbonController = CarbonStatController();

  //collects all info and merges it into one large tuple.
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

    var fut = toList();
    late List<BarChartGroupData> rawBarGroups;
    
    //The main function, it unpacks the data and fills it into a graph.
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

          //Converts tuple into 2 lists, so its easier to work with (and nicer to read)
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

          final barchart1 = makeGroupData(0, vals, col);
          final items = [
            barchart1
            /*
              insert more barcharts if needed.
              */
          ];
          rawBarGroups = items;
          final barChart = BarChart(BarChartData(
            maxY: vals.reduce(max) + 100,
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
            SizedBox(
              height: 300,
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

//this creates the names under the graph, so you can associate colours with names.
List<Widget> createNames(List<String> names, List<Color> col) {
  List<Widget> res = [];
  for (int i = 0; i < names.length; i++) {
    res = res +
        [
          Indicator(
            color: col[i],
            text: "${names[i]}   ",
            isSquare: true,
            size: 20,
            textSize: 13
          )
        ];
  }
  return res;
}
//creates the pilars in the barchart.
BarChartGroupData makeGroupData(int x, List<double> y, List<Color> col) {
  return BarChartGroupData(
    barsSpace: 4,
    x: x,
    barRods: createBarchart(y, col),
  );
}
//extension of previous function.
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
