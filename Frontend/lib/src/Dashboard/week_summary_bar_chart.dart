import 'dart:async';
import 'dart:math';

import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'dart:convert';
import 'package:carbon_footprint/src/user_controller.dart';


class WeekSummaryBarChart extends StatefulWidget {
  WeekSummaryBarChart({super.key});

  List<Color> get availableColors => const <Color>[
        Colors.purple,
        Colors.yellow,
        Colors.blue,
        Colors.orange,
        Colors.pink,
        Colors.red,
      ];

  final Color barBackgroundColor = Colors.lightBlueAccent.withOpacity(0.3);
  final Color barColor = Colors.amber;
  final Color touchedBarColor = Colors.black;

  @override
  State<StatefulWidget> createState() => WeekSummaryBarChartState();
}

class WeekSummaryBarChartState extends State<WeekSummaryBarChart> {
  final Duration animDuration = const Duration(milliseconds: 250);
    Future<List<double>> last7days() async {
      print("last7days has been called");
      //var items = await carbonTrackerItems;
      http.Request request = http.Request(
          "GET", Uri.parse('${SettingsController.address}/actionTracker'));
      request.body = jsonEncode(<String, String>{
        'User': UserController().username,
      });
      request.headers.addAll(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
      
      http.Request request2 = http.Request(
          "GET", Uri.parse('${SettingsController.address}/userScore'));
      request2.body = jsonEncode(<String, String>{
        'User': UserController().username,
      });
      request2.headers.addAll(<String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

      var response = await request.send();
  print("2nd thing work");
      var items = await response.stream.transform(utf8.decoder).first;
      print("3rd thing work");
      var res = jsonDecode(items);
      print(res);

      var response2 = await request2.send();
      var baseYearly = await response2.stream.transform(utf8.decoder).first;
      var baseDaily = double.parse(baseYearly)/365;
      print("BaseYearly/actual carbonscore:");
      print(baseYearly);
      print("BaseDaily:");
      print(baseDaily);
      var date = DateTime.now();
      List<double> list = [0, 0, 0, 0, 0, 0, 0];
      for (var i = 0; i < items.length; i++) {
          print(items[i]);
          //list[diff.inDays] += items[i].carbonScore;
          list[i] += baseDaily-i*2;
        
    }
/*
    for (var i = 0; i < items.length; i++) {
      var diff = date.difference(items[i].dateAdded);
      if (diff.inDays <= 7 && diff.inDays >= 0) {
        //list[diff.inDays] += items[i].carbonScore;
        list[diff.inDays] += baseDaily;
      }
    }
*/
      return list;
  }
  int touchedIndex = -1;

  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: last7days(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return AspectRatio(
            aspectRatio: 1,
            child: Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Text(
                        'Past 7 days',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: BarChart(
                            isPlaying
                                ? randomData()
                                : mainBarData(snapshot.data!),
                            swapAnimationDuration: animDuration,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onDoubleTap: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    if (isPlaying) {
                      refreshState();
                    }
                  });
                },
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('error: ${snapshot.error.toString()}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.black, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups(List<double> data) =>
      List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, data[6], isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, data[5], isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, data[4], isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, data[3], isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, data[2], isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, data[1], isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, data[0], isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  String getWeekDay(int week, {bool char = true}) {
    if (week <= 0) week += 7;

    String weekDay = '';
    switch (week) {
      case 1:
        weekDay = 'Monday';
      case 2:
        weekDay = 'Tuesday';
      case 3:
        weekDay = 'Wednesday';
      case 4:
        weekDay = 'Thursday';
      case 5:
        weekDay = 'Friday';
      case 6:
        weekDay = 'Saturday';
      case 7:
        weekDay = 'Sunday';
      default:
        throw Error();
    }
    if (char) weekDay = weekDay[0];

    return weekDay;
  }

  BarChartData mainBarData(List<double> data) {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.right,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            int day = DateTime.now().weekday;
            switch (group.x) {
              case 0:
                weekDay = getWeekDay(day - 6, char: false);
                break;
              case 1:
                weekDay = getWeekDay(day - 5, char: false);
                break;
              case 2:
                weekDay = getWeekDay(day - 4, char: false);
                break;
              case 3:
                weekDay = getWeekDay(day - 3, char: false);
                break;
              case 4:
                weekDay = getWeekDay(day - 2, char: false);
                break;
              case 5:
                weekDay = getWeekDay(day - 1, char: false);
                break;
              case 6:
                weekDay = getWeekDay(day, char: false);
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
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
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(data),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    int day = DateTime.now().weekday;
    switch (value.toInt()) {
      case 0:
        text = Text(getWeekDay(day - 6), style: style);
        break;
      case 1:
        text = Text(getWeekDay(day - 5), style: style);
        break;
      case 2:
        text = Text(getWeekDay(day - 4), style: style);
        break;
      case 3:
        text = Text(getWeekDay(day - 3), style: style);
        break;
      case 4:
        text = Text(getWeekDay(day - 2), style: style);
        break;
      case 5:
        text = Text(getWeekDay(day - 1), style: style);
        break;
      case 6:
        text = Text(getWeekDay(day), style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  BarChartData randomData() {
    return BarChartData(
      barTouchData: BarTouchData(
        enabled: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
              0,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 1:
            return makeGroupData(
              1,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 2:
            return makeGroupData(
              2,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 3:
            return makeGroupData(
              3,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 4:
            return makeGroupData(
              4,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 5:
            return makeGroupData(
              5,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          case 6:
            return makeGroupData(
              6,
              Random().nextInt(15).toDouble() + 6,
              barColor: widget.availableColors[
                  Random().nextInt(widget.availableColors.length)],
            );
          default:
            return throw Error();
        }
      }),
      gridData: const FlGridData(show: false),
    );
  }

  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(
      animDuration + const Duration(milliseconds: 50),
    );
    if (isPlaying) {
      await refreshState();
    }
  }
}
