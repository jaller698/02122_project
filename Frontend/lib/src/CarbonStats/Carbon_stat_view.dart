import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carbon_footprint/src/Dashboard/ChartStuff/indicator.dart';

import 'Carbon_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';

class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});

  static const routeName = '/carbonstats';

  static final CarbonStatController _carbonController = CarbonStatController();

  Future<List<String>> toList(String Comp) async {
    Future<List<String>> fut = Future(()async => [await _carbonController.fetchStats(UserController().username),await _carbonController.fetchStats(Comp)] );
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
     final barGroup1 = makeGroupData(0, 5, 12);
     final items = [
      barGroup1,
    /*  barGroup2,
      barGroup3,
      barGroup4,
      barGroup5,
      barGroup6,
      barGroup7,*/
    ];
    rawBarGroups = items;
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
                      text: "Guest   ",
                      isSquare: true,
                      size: 40,
                      textColor: Colors.black
                    )]
                  );
    final barChart = BarChart(
      BarChartData(
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
    return FutureBuilder(
      future: fut,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              //itemCount: 2,
              //itemBuilder: (context, index) {
                //String k = snapshot.data![0];
                //String k2 = snapshot.data![1];
                children: <Widget> [
                  Container (
                   height: 600,
                   child: barChart,
                  ), 
                  colorIndicators
                ]
                
                  );

              
      
        } else if (snapshot.hasError) {
          return Center(child: Text('error: ${snapshot.error.toString()}'));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
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