import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Modals/carbon_form_answer.dart';

class CarbonFormHistoryController with ChangeNotifier {
  // singleton
  CarbonFormHistoryController._hiddenConstructor();
  static final CarbonFormHistoryController _singleton =
      CarbonFormHistoryController._hiddenConstructor();
  factory CarbonFormHistoryController() => _singleton;

  List<CarbonFormAnswer>? _carbonForms;
  Future<List<CarbonFormAnswer>> get carbonForms {
    if (_carbonForms == null) {
      return loadForms();
    }
    return Future(() => _carbonForms!);
  }

  static late Future<Database> _database;

  Future<List<CarbonFormAnswer>> loadForms() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'form_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE form(count INTEGER PRIMARY KEY, title TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, Object?>> carbonFormMaps =
        await (await _database).query('form');

    final form = [
      for (final Map<String, dynamic> map in carbonFormMaps)
        CarbonFormAnswer.fromMap(map),
    ];

    _carbonForms = form;

    return form;
  }

  Future<void> addForm(CarbonFormAnswer item) async {
    final db = await _database;

    var itemMap = CarbonFormAnswer.toMap(item);

    var itemList = await carbonForms;

    for (var i = 0; i < itemList.length; i++) {
      bool valid = true;
      for (var item in itemList) {
        if (item.id == i) valid = false;
      }

      if (valid) {
        itemMap['count'] = i;
        break;
      }
    }

    print(itemMap);

    await db.insert(
      'form',
      itemMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadForms();
  }

  Future<void> removeForm(int id) async {
    final db = await _database;

    await db.delete(
      'form',
      where: 'count = ?',
      whereArgs: [id],
    );

    await loadForms();
  }
}
