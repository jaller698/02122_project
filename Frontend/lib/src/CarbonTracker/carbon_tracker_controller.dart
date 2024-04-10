import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CarbonTrackerController {
  // singleton
  CarbonTrackerController._hiddenConstructor();
  static final CarbonTrackerController _singleton =
      CarbonTrackerController._hiddenConstructor();
  factory CarbonTrackerController() => _singleton;

  static List<CarbonTrackerItem>? _carbonTrackerItems;
  static Future<List<CarbonTrackerItem>> get carbonTrackerItems {
    if (_carbonTrackerItems == null) {
      return loadTrackerItems();
    }
    return Future(() => _carbonTrackerItems!);
  }

  static late Future<Database> _database;

  static Future<List<CarbonTrackerItem>> loadTrackerItems() async {
    print('opendatabase');
    _database = openDatabase(
      join(await getDatabasesPath(), 'tracker_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carbon(id INTEGER PRIMARY KEY, name TEXT, type BLOB, score INTEGER, date TEXT)',
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
            'type': type as CarbonTackerType,
            'score': carbonScore as int,
            'date': dateAdded as String,
          } in carbonItemsMaps)
        CarbonTrackerItem(id, name, type, carbonScore,
            DateTime.tryParse(dateAdded) ?? DateTime(0)),
    ];

    _carbonTrackerItems = items;

    return items;
  }

  static Future<void> updateTrackerItems(CarbonTrackerItem item) async {
    final db = await _database;

    await db.update(
      'carbon',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    await loadTrackerItems();
  }

  static Future<void> addTrackerItem(CarbonTrackerItem item) async {
    final db = await _database;

    await db.insert(
      'carbon',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadTrackerItems();
  }

  static Future<void> removeTrackerItem(int id) async {
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
  final int id;
  final String name;
  final CarbonTackerType type;
  final int carbonScore;
  final DateTime dateAdded;

  CarbonTrackerItem(
    this.id,
    this.name,
    this.type,
    this.carbonScore,
    this.dateAdded,
  );

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'score': carbonScore,
      'date': dateAdded,
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
  walking(Icons.directions_walk, 'by foot'),
  cycling(Icons.directions_bike, 'by bicycle'),
  car(Icons.directions_car, 'by car'),
  bus(Icons.directions_bus, 'by bus'),
  train(Icons.directions_train, 'by train'),
  boat(Icons.directions_boat, 'by boat'),
  flight(Icons.flight, 'by plane'),

  // food

  // custom
  custom(Icons.tune, '');

  final IconData icon;
  final String text;

  const CarbonTackerType(this.icon, this.text);
}
