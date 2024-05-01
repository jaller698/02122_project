import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CarbonTrackerController with ChangeNotifier {
  // singleton
  CarbonTrackerController._hiddenConstructor();
  static final CarbonTrackerController _singleton =
      CarbonTrackerController._hiddenConstructor();
  factory CarbonTrackerController() => _singleton;

  List<CarbonTrackerItem>? _carbonTrackerItems;
  Future<List<CarbonTrackerItem>> get carbonTrackerItems {
    if (_carbonTrackerItems == null) {
      return loadTrackerItems();
    }
    return Future(() => _carbonTrackerItems!);
  }

  static late Future<Database> _database;

  Future<List<CarbonTrackerItem>> loadTrackerItems() async {
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

  Future<void> updateTrackerItems(CarbonTrackerItem item) async {
    final db = await _database;

    await db.update(
      'carbon',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    await loadTrackerItems();
  }

  Future<void> addTrackerItem(CarbonTrackerItem item) async {
    final db = await _database;

    var itemMap = item.toMap();

    itemMap['id'] = _carbonTrackerItems?.length ?? 0;

    await db.insert(
      'carbon',
      itemMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadTrackerItems();
  }

  Future<void> removeTrackerItem(int id) async {
    final db = await _database;

    await db.delete(
      'carbon',
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadTrackerItems();
  }
}

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
  custom(Icons.tune, [
    CarbonTackerType.custom,
  ]);

  final IconData icon;
  final List<CarbonTackerType> types;

  const CarbonTrackerCategory(this.icon, this.types);
}

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

  // shopping
  // TODO design a better system, best if the user is also able to add custom items to track...

  // custom
  custom(Icons.tune, '', CarbonTrackInputTypes.custom);

  final IconData icon;
  final String text;

  final CarbonTrackInputTypes type;

  const CarbonTackerType(this.icon, this.text, this.type);
}

enum CarbonTrackInputTypes { single, time, distance, custom }

// save to json string
class CarbonTrackerObjectType {
  // icon
  // name
  // input type

  // ! to map
}

class CarbonTrackerObjectCategory {
  // icon
  // list of types

  // ! to map
}

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
