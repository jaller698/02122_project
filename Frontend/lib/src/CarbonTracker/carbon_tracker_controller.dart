import 'dart:async';
import 'dart:convert';

import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

// written by Martin, and Christian
// sql lite singleton controller which handles the users history of tracker items they have added
class CarbonTrackerController with ChangeNotifier {
  // singleton
  CarbonTrackerController._hiddenConstructor();
  static final CarbonTrackerController _singleton =
      CarbonTrackerController._hiddenConstructor();
  factory CarbonTrackerController() => _singleton;

  // add a single new item
  Future<void> addTrackerItem(CarbonTrackerItem item) async {
    sendToServer(item);
  }

  void sendToServer(CarbonTrackerItem item) {
    // send to server
    Map data = Map.from(item.toMap());
    data.addAll({'user': UserController().username});
    http.post(Uri.parse('${SettingsController.address}/actionTracker'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data));
  }
}

// written by Martin,
// class for carbon item, in an object format instead of map
class CarbonTrackerItem {
  final int? id;
  final String name;
  final CarbonTackerType type;
  final int carbonScore;
  final DateTime dateAdded;

  CarbonTrackerItem(
    this.name,
    this.type,
    this.carbonScore,
    this.dateAdded, {
    this.id,
  });

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.name,
      'score': carbonScore,
      'date': dateAdded.toString(),
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: ${type.toString()}, score: $carbonScore, date: ${dateAdded.toString()}}';
  }
}

// written by Martin,
// enum over categories
enum CarbonTrackerCategory {
  transport(Icons.explore, [
    CarbonTackerType.walking,
    CarbonTackerType.cycling,
    CarbonTackerType.car,
    CarbonTackerType.bus,
    CarbonTackerType.train,
    CarbonTackerType.boat,
    CarbonTackerType.flight,
  ]),
  carbonSaving(Icons.show_chart_rounded, [
    CarbonTackerType.meatFreeDay,
    CarbonTackerType.bikeToWork,
  ]),
  custom(Icons.tune, [
    CarbonTackerType.custom,
  ]);

  final IconData icon;
  final List<CarbonTackerType> types;

  const CarbonTrackerCategory(this.icon, this.types);
}

// written by Martin,
// enum over types of actions
enum CarbonTackerType {
  // transport
  walking(Icons.directions_walk, 'walk', CarbonTrackInputTypes.time),
  cycling(Icons.directions_bike, 'bicycle trip', CarbonTrackInputTypes.time),
  car(Icons.directions_car, 'car trip', CarbonTrackInputTypes.time),
  bus(Icons.directions_bus, 'bus trip', CarbonTrackInputTypes.time),
  train(Icons.directions_train, 'train trip', CarbonTrackInputTypes.time),
  boat(Icons.directions_boat, 'boat trip', CarbonTrackInputTypes.time),
  flight(Icons.flight, 'plane trip', CarbonTrackInputTypes.time),

  //carbon saving
  meatFreeDay(Icons.emoji_food_beverage_rounded, 'Meat free day',
      CarbonTrackInputTypes.carbonSaving),
  bikeToWork(Icons.bike_scooter, 'Biked to work instead of taking the car',
      CarbonTrackInputTypes.carbonSaving),
  // shopping

  // custom
  custom(Icons.tune, '', CarbonTrackInputTypes.custom);

  final IconData icon;
  final String text;

  final CarbonTrackInputTypes type;

  const CarbonTackerType(this.icon, this.text, this.type);
}

// written by Martin,
// enum of all supported input types
enum CarbonTrackInputTypes { single, time, distance, custom, carbonSaving }
