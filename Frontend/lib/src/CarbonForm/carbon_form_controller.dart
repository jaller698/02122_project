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
          'CREATE TABLE form(id INTEGER PRIMARY KEY, title TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, Object?>> carbonFormMaps =
        await (await _database).query('form');

    final items = [
      for (final Map<String, dynamic> map in carbonFormMaps)
        CarbonFormAnswer.fromMap(map),
    ];

    _carbonForms = items;

    notifyListeners();

    return items;
  }

  Future<void> addForm(CarbonFormAnswer item) async {
    final db = await _database;

    var itemMap = CarbonFormAnswer.toMap(item);

    itemMap['id'] = _carbonForms?.length ?? 0;

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
      where: 'id = ?',
      whereArgs: [id],
    );

    await loadForms();
  }
}
