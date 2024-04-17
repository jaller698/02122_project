import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_controller.dart';
import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  CarbonTrackerView({super.key});

  final CarbonTrackerController control = CarbonTrackerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: CarbonTrackerController(),
        builder: (context, child) {
          return FutureBuilder(
            future: control.carbonTrackerItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final count = snapshot.data!.length - 1;
                return ListView.builder(
                  itemCount: count + 1,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![count - index];
                    return ListTile(
                      leading: Icon(item.type.icon),
                      title: Text(item.name),
                      subtitle: Text(item.type.text),
                      onTap: () {
                        control.removeTrackerItem(item.id!);
                      },
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('error: ${snapshot.error.toString()}');
              } else {
                return const CircularProgressIndicator();
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Record action'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            constraints: const BoxConstraints(maxHeight: 400),
            context: context,
            showDragHandle: true,
            builder: (context) {
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: CarbonTrackerCategory.values.length,
                  itemBuilder: (context, index) {
                    final category = CarbonTrackerCategory.values[index];
                    return Card(
                      child: ListTile(
                        style: ListTileStyle.drawer,
                        leading: Icon(category.icon),
                        title: Text(category.name),
                        onTap: () {
                          showModalBottomSheet(
                            constraints: const BoxConstraints(maxHeight: 400),
                            context: context,
                            showDragHandle: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return SizedBox(
                                height: 500,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: category.types.length,
                                  itemBuilder: (context, index) {
                                    final type = category.types[index];
                                    return Card(
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Icon(type.icon),
                                        title: Text(type.text),
                                        onTap: () {
                                          control.addTrackerItem(
                                            CarbonTrackerItem(
                                              type.name,
                                              type,
                                              4000,
                                              DateTime.now(),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CarbonTrackItem {}

// to track
//  travel
//    by foot
//    car
//      electric
//        hybrid
//      petrol
//      diesel
//    bus
//    train
//    plane
//      distance (choose in settings?)
//      time
//  food
//    meat
//      fish
//      meat (low to high)
//    dairy
//    vegan
//  shopping
//    clothes
//      fast fashion
//    electronics (large to small)
//  energy consumption 
//    region
//      coal
//      natrual gas
//      wind
//      solar
//      hydro
//      nuclear
//    by month?


// form creater on website
//    creation from ymal or json file
