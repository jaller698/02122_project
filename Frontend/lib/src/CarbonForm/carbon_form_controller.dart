import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Modals/carbon_form.dart';

class CarbonFormController with ChangeNotifier {
  // singleton
  CarbonFormController._hiddenConstructor();
  static final CarbonFormController _singleton =
      CarbonFormController._hiddenConstructor();
  factory CarbonFormController() => _singleton;

  List<CarbonForm>? _carbonTrackerItems;
  Future<List<CarbonForm>> get carbonTrackerItems {
    if (_carbonTrackerItems == null) {
      return loadTrackerItems();
    }
    return Future(() => _carbonTrackerItems!);
  }

  static late Future<Database> _database;

  Future<List<CarbonForm>> loadTrackerItems() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'form_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE carbon(id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, Object?>> carbonItemsMaps =
        await (await _database).query('form');

    final items = [
      for (final {
            'id': id as int,
            'name': title as String,
          } in carbonItemsMaps)
        CarbonForm(
          id: id,
          title: title,
          questions: [],
        ),
    ];

    _carbonTrackerItems = items;

    notifyListeners();

    return items;
  }

  Future<void> updateTrackerItems(CarbonForm item) async {
    final db = await _database;

    await db.update(
      'carbon',
      CarbonForm.toMap(item),
      where: 'id = ?',
      whereArgs: [item.id],
    );

    await loadTrackerItems();
  }

  Future<void> addTrackerItem(CarbonForm item) async {
    final db = await _database;

    var itemMap = CarbonForm.toMap(item);

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