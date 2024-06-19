import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Modals/carbon_form.dart';

// written by Martin,
// singleton controller which saves and persistently keeps the latest form loaded from the server
class CarbonFormPendingController with ChangeNotifier {
  // singleton
  CarbonFormPendingController._hiddenConstructor();
  static final CarbonFormPendingController _singleton =
      CarbonFormPendingController._hiddenConstructor();
  factory CarbonFormPendingController() => _singleton;

  // private variable, which forces an initialization on first access
  CarbonForm? _carbonForm;
  Future<CarbonForm> get carbonForm {
    if (_carbonForm == null) {
      return loadForms();
    }
    return Future(() => _carbonForm!);
  }

  // loads the last saved form, if it exists
  Future<CarbonForm> loadForms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString('pendingForm');
    CarbonForm form = data != null
        ? CarbonForm.fromMap(jsonDecode(data))
        : const CarbonForm(title: 'error', questions: []);

    _carbonForm = form;

    notifyListeners();
    return form;
  }

  // saves a new form
  Future<void> saveForm(CarbonForm form) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = jsonEncode(CarbonForm.toMap(form));
    await prefs.setString('pendingForm', data);

    _carbonForm = form;
    notifyListeners();
  }

  // deletes a form
  Future<void> removeForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('pendingForm');

    _carbonForm = null;
  }
}
