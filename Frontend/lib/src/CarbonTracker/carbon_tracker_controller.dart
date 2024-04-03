import 'package:localstore/localstore.dart';

class CarbonTrackerController {
  static Map<DateTime, dynamic>? _carbonTrackerItems;
  static Map<DateTime, dynamic> get carbonTrackerItems {
    if (_carbonTrackerItems == null) {
      loadTrackerItems().then((value) => _carbonTrackerItems);
    }
    return _carbonTrackerItems!;
  }

  static final db = Localstore.instance;
  // use shared_preferences
  static Future<Map<DateTime, dynamic>> loadTrackerItems() async {
    final id = db.collection('carbontracker').doc().id;
    _carbonTrackerItems = <DateTime, dynamic>{};
    db.collection('carbontracker').doc(id).get().then(
      (value) {
        if (value == null) {
          return;
        }

        for (var date in value.keys) {
          _carbonTrackerItems![DateTime.parse(date)] = value[date];
        }
      },
    );

    return _carbonTrackerItems!;
  }

  static Future<Map<DateTime, dynamic>> retriveTrackerItems() async {
    return _carbonTrackerItems ?? await loadTrackerItems();
  }

  static Future<void> updateTrackerItems() async {}

  static Future<void> addTrackerItem() async {}
}
