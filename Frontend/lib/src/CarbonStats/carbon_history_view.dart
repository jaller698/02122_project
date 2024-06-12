import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'carbon_history_controller.dart';

// written by // TODO
//
class CarbonHistoryView extends StatefulWidget {
  const CarbonHistoryView({Key? key}) : super(key: key);

  @override
  _CarbonHistoryViewState createState() => _CarbonHistoryViewState();
}

class _CarbonHistoryViewState extends State<CarbonHistoryView> {
  List<Color> gradientColors = [Colors.cyan, Colors.blue];

  bool showAvg = false;

  static final CarbonHistoryController _historyController =
      CarbonHistoryController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _historyController.fetchHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.70,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 18,
                      left: 12,
                      top: 24,
                      bottom: 12,
                    ),
                    child: LineChart(
                      mainData(snapshot),
                    ),
                  ),
                ),
              ],
            );
          } else {
            if (snapshot.hasError) print(snapshot.error);
            return CircularProgressIndicator();
          }
        });
  }

  LineChartData mainData(snapshot) {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: snapshot.data.length.toDouble() - 1,
      minY: 0,
      maxY: _historyController.maxScore,
      lineBarsData: [
        LineChartBarData(
          spots: getLineSpots(snapshot),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  List<FlSpot> getLineSpots(snapshot) {
    List<FlSpot> spots = [];
    for (int i = 0; i < snapshot.data.length; i++) {
      spots.add(FlSpot(i.toDouble(), snapshot.data[i].score.toDouble()));
    }
    return spots;
  }
}
