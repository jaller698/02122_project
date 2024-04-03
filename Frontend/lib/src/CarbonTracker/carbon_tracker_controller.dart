class CarbonTrackerController {
  static Map<DateTime, CarbonTrackerItem>? _carbonTrackerItems;

  // use shared_preferences
  Future<void> loadTrackerItems() async {}

  Future<Map<DateTime, CarbonTrackerItem>> retriveTrackerItems() async {
    return _carbonTrackerItems!;
  }

  Future<void> updateTrackerItems() async {}

  Future<void> addTrackerItem() async {}
}

class CarbonTrackerItem {}
