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
    print('opendatabase');
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
  food(Icons.restaurant, []),
  custom(Icons.tune, [CarbonTackerType.custom]);

  final IconData icon;
  final List<CarbonTackerType> types;

  const CarbonTrackerCategory(this.icon, this.types);
}

enum CarbonTackerType {
  // transport
  walking(Icons.directions_walk, 'walk'),
  cycling(Icons.directions_bike, 'bicycle trip'),
  car(Icons.directions_car, 'car trip'),
  bus(Icons.directions_bus, 'bus trip'),
  train(Icons.directions_train, 'train trip'),
  boat(Icons.directions_boat, 'boat trip'),
  flight(Icons.flight, 'plane trip'),

  // food

  // custom
  custom(Icons.tune, '');

  final IconData icon;
  final String text;

  const CarbonTackerType(this.icon, this.text);
}
