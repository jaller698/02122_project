import 'dart:async';
import 'dart:convert';

import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

// written by Martin,
// sql lite singleton controller which handles the users history of tracker items they have added
class CarbonTrackerController with ChangeNotifier {
  // singleton
  CarbonTrackerController._hiddenConstructor();
  static final CarbonTrackerController _singleton =
      CarbonTrackerController._hiddenConstructor();
  factory CarbonTrackerController() => _singleton;

  // private variable, which forces an initialization on first access
  List<CarbonTrackerItem>? _carbonTrackerItems;
  Future<List<CarbonTrackerItem>> get carbonTrackerItems async {
    if (_carbonTrackerItems == null) {
      var list = await loadTrackerItems();
      list.sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      return list;
    }
    return Future(() => _carbonTrackerItems!);
  }

  // sql lite database
  static late Future<Database> _database;

  // loads and returns all items the user has added
  Future<List<CarbonTrackerItem>> loadTrackerItems() async {
    // TODO - path not able to be found on windows, linux and web
    _database = openDatabase(
      join(await getDatabasesPath(), 'tracker_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carbon(id INTEGER PRIMARY KEY, name TEXT, type TEXT, score INTEGER, date TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, Object?>> carbonItemsMaps =
        await (await _database).query('carbon');

    // carbon tracker item conversion from map to a list of objects
    final items = [
      for (final {
            'id': id as int,
            'name': name as String,
            'type': type as String,
            'score': carbonScore as int,
            'date': dateAdded as String,
          } in carbonItemsMaps)
        CarbonTrackerItem(name, CarbonTackerType.values.byName(type),
            carbonScore, DateTime.tryParse(dateAdded) ?? DateTime(0),
            id: id),
    ];

    _carbonTrackerItems = items;

    notifyListeners();

    return items;
  }

  // updates a single item, by replacement
  Future<void> updateTrackerItems(CarbonTrackerItem item) async {
    final db = await _database;

    await db.update(
      'carbon',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    //TODO, if this is used call updateServer()

    await loadTrackerItems();
  }

  // add a single new item
  Future<void> addTrackerItem(CarbonTrackerItem item) async {
    final db = await _database;

    var itemMap = item.toMap();

    var itemList = await carbonTrackerItems;

    for (var i = 0; i < itemList.length; i++) {
      bool valid = true;
      for (var item in itemList) {
        if (item.id == i) valid = false;
      }

      if (valid) {
        itemMap['id'] = i;
        break;
      }
    }

    await db.insert(
      'carbon',
      itemMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    sendToServer(item);

    await loadTrackerItems();
  }

  // removes an item based on id
  Future<void> removeTrackerItem(int id) async {
    final db = await _database;

    await db.delete(
      'carbon',
      where: 'id = ?',
      whereArgs: [id],
    );

    deleteFromServer(id);

    await loadTrackerItems();
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

  void deleteFromServer(int id) {
    // delete from server
    // TODO is this needed?
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
  food(Icons.restaurant, [
    CarbonTackerType.lowMeat,
    CarbonTackerType.highMeat,
    CarbonTackerType.grain,
    CarbonTackerType.dairy,
    CarbonTackerType.fish,
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

  // food
  lowMeat(Icons.brunch_dining, 'Low meat meal', CarbonTrackInputTypes.single),
  highMeat(Icons.lunch_dining, 'High meat meal', CarbonTrackInputTypes.single),
  grain(Icons.bakery_dining, 'Grain based meal', CarbonTrackInputTypes.single),
  dairy(Icons.calendar_today_rounded, 'Dairy based meal',
      CarbonTrackInputTypes.single),
  fish(Icons.set_meal, 'Fish based meal', CarbonTrackInputTypes.single),

  meatFreeDay(Icons.emoji_food_beverage_rounded, 'Meat free day',
      CarbonTrackInputTypes.carbonSaving),
  bikeToWork(Icons.bike_scooter, 'Biked to work instead of taking the car',
      CarbonTrackInputTypes.carbonSaving),
  // shopping
  // TODO design a better system, best if the user is also able to add custom items to track...

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

// written by Martin,
// enum of all icons
enum CarbonTrackerObjectIcons {
  // transport
  walking(Icons.directions_walk),
  cycling(Icons.directions_bike),
  car(Icons.directions_car),
  bus(Icons.directions_bus),
  train(Icons.directions_train),
  boat(Icons.directions_boat),
  flight(Icons.flight),

  // food
  lowMeat(Icons.brunch_dining),
  highMeat(Icons.lunch_dining),
  grain(Icons.bakery_dining),
  dairy(Icons.calendar_today_rounded),
  fish(Icons.set_meal),

  // categories
  transport(Icons.explore),
  food(Icons.restaurant),
  custom(Icons.tune);

  final IconData icon;

  const CarbonTrackerObjectIcons(this.icon);
}


// to track
//  travel
//    by foot
//    car
//      electric
//        hybrid
//      petrol
//      diesel
//    bus
//    train
//    plane
//      distance (choose in settings?)
//      time
//  food
//    meat
//      fish
//      meat (low to high)
//    dairy
//    vegan
//  shopping
//    clothes
//      fast fashion
//    electronics (large to small)
//  energy consumption 
//    region
//      coal
//      natrual gas
//      wind
//      solar
//      hydro
//      nuclear
//    by month?


// form creater on website
//    creation from ymal or json file
