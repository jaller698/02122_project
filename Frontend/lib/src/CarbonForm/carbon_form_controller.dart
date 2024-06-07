import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Modals/carbon_form_answer.dart';

class CarbonFormController with ChangeNotifier {
  // singleton
  CarbonFormController._hiddenConstructor();
  static final CarbonFormController _singleton =
      CarbonFormController._hiddenConstructor();
  factory CarbonFormController() => _singleton;

  List<CarbonFormAnswer>? _carbonTrackerItems;
  Future<List<CarbonFormAnswer>> get carbonTrackerItems {
    if (_carbonTrackerItems == null) {
      return loadTrackerItems();
    }
    return Future(() => _carbonTrackerItems!);
  }

  static late Future<Database> _database;

  Future<List<CarbonFormAnswer>> loadTrackerItems() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'form_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE form(id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, Object?>> carbonItemsMaps =
        await (await _database).query('form');

    final items = [
      for (final Map<String, dynamic> map in carbonItemsMaps)
        CarbonFormAnswer.fromMap(map),
    ];

    _carbonTrackerItems = items;

    notifyListeners();

    return items;
  }

  Future<void> updateTrackerItems(CarbonFormAnswer item) async {
    final db = await _database;

    await db.update(
      'form',
      CarbonFormAnswer.toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    await loadTrackerItems();
  }

  Future<void> addTrackerItem(CarbonFormAnswer item) async {
    final db = await _database;

    var itemMap = CarbonFormAnswer.toMap(item);

    itemMap['id'] = _carbonTrackerItems?.length ?? 0;

    await db.insert(
      'form',
      itemMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadTrackerItems();
  }

  Future<void> removeTrackerItem(int id) async {
    final db = await _database;

    await db.delete(
      'form',
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadTrackerItems();
  }
}
