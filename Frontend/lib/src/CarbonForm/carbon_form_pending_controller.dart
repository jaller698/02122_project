import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Modals/carbon_form.dart';

class CarbonFormPendingController with ChangeNotifier {
  // singleton
  CarbonFormPendingController._hiddenConstructor();
  static final CarbonFormPendingController _singleton =
      CarbonFormPendingController._hiddenConstructor();
  factory CarbonFormPendingController() => _singleton;

  CarbonForm? _carbonForm;

  Future<CarbonForm> get carbonForm {
    if (_carbonForm == null) {
      return loadForms();
    }
    return Future(() => _carbonForm!);
  }

  Future<CarbonForm> loadForms() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? data = prefs.getString('pendingForm');
    CarbonForm form = data != null
        ? CarbonForm.fromMap(jsonDecode(data))
        : const CarbonForm(title: 'error', questions: []);

    notifyListeners();
    return form;
  }

  Future<void> saveForm(CarbonForm form) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String data = jsonEncode(CarbonForm.toMap(form));
    await prefs.setString('pendingForm', data);

    _carbonForm = form;
    notifyListeners();
  }

  Future<void> removeForm() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('pendingForm');

    _carbonForm = null;
  }
}
