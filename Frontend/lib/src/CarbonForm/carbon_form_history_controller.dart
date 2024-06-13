import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Modals/carbon_form_answer.dart';

// written by Martin,
// sql lite singleton controller which handles the users history of completed forms
class CarbonFormHistoryController with ChangeNotifier {
  // singleton
  CarbonFormHistoryController._hiddenConstructor();
  static final CarbonFormHistoryController _singleton =
      CarbonFormHistoryController._hiddenConstructor();
  factory CarbonFormHistoryController() => _singleton;

  // private variable, which forces an initialization on first access
  List<CarbonFormAnswer>? _carbonForms;
  Future<List<CarbonFormAnswer>> get carbonForms {
    if (_carbonForms == null) {
      return loadForms();
    }
    return Future(() => _carbonForms!);
  }

  // sql lite database
  static late Future<Database> _database;

  // loads and returns all completed forms
  Future<List<CarbonFormAnswer>> loadForms() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'form_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE form(count INTEGER PRIMARY KEY, json TEXT)',
        );
      },
      version: 1,
    );

    final List<Map<String, Object?>> carbonFormMaps =
        await (await _database).query('form');

    List<CarbonFormAnswer> list = [];

    for (final Map<String, dynamic> map in carbonFormMaps) {
      list.add(CarbonFormAnswer.fromMap(jsonDecode(map['json'])));
    }

    _carbonForms = list;

    return list;
  }

  // add a new completed form to keep
  Future<void> addForm(CarbonFormAnswer item) async {
    final db = await _database;

    Map<String, dynamic> itemMap = {
      'json': jsonEncode(CarbonFormAnswer.toMap(item))
    };

    var itemList = await carbonForms;

    // solution to prevent duplicate ids
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

    await db.insert(
      'form',
      itemMap,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await loadForms();

    notifyListeners();
  }

  // remove a form from history
  Future<void> removeForm(int id) async {
    final db = await _database;

    await db.delete(
      'form',
      where: 'count = ?',
      whereArgs: [id],
    );

    await loadForms();

    notifyListeners();
  }
}
