import 'package:flutter/material.dart';

// written by Martin, // TODO
//
class CarbonTrackerControllerNew {
  // save

  // load
}

class CarbonTrackerItem {
  CarbonTrackerItem(this.type, this.usage);

  CarbonTrackerType type;
  int usage;
}

class CarbonTrackerType {
  CarbonTrackerType(this.name, this.input);

  String name;
  CarbonTrackInputTypes input;
}

enum CarbonTrackInputTypes {
  single,
  time,
  distance,
}

enum CarbonTrackerObjectIcons {
  // transport
  walking(Icons.directions_walk),
  cycling(Icons.directions_bike),
  car(Icons.directions_car),
  bus(Icons.directions_bus),
  train(Icons.directions_train),
  boat(Icons.directions_boat),
  flight(Icons.flight),

  // food
  lowMeat(Icons.brunch_dining),
  highMeat(Icons.lunch_dining),
  grain(Icons.bakery_dining),
  dairy(Icons.calendar_today_rounded),
  fish(Icons.set_meal),

  // categories
  transport(Icons.explore),
  food(Icons.restaurant),
  custom(Icons.tune);

  final IconData icon;

  const CarbonTrackerObjectIcons(this.icon);
}
