import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_controller.dart';
import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  const CarbonTrackerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: CarbonTrackerController.carbonTrackerItems,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = snapshot.data![index];
                return ListTile(
                  leading: Icon(item.type.icon),
                  title: Text(item.name),
                  subtitle: Text(item.type.text),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('error: ${snapshot.error.toString()}');
          } else {
            return const CircularProgressIndicator();
          }
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListView.builder(
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
                                  constraints:
                                      const BoxConstraints(maxHeight: 400),
                                  context: context,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 500,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(8.0),
                                        itemBuilder: (context, index) {
                                          final type = category.types[index];
                                          return Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading: Icon(type.icon),
                                              title: Text(type.text),
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
                      ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: <Widget>[
                          Card(
                            child: ListTile(
                              style: ListTileStyle.drawer,
                              leading: const Icon(Icons.explore),
                              title: const Text('Transport'),
                              onTap: () {
                                showModalBottomSheet(
                                  constraints:
                                      const BoxConstraints(maxHeight: 400),
                                  context: context,
                                  showDragHandle: true,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 500,
                                      child: ListView(
                                        padding: const EdgeInsets.all(8.0),
                                        children: const <Widget>[
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading:
                                                  Icon(Icons.directions_walk),
                                              title: Text('by Foot'),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading:
                                                  Icon(Icons.directions_bike),
                                              title: Text('by Bicycle'),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading:
                                                  Icon(Icons.directions_car),
                                              title: Text('by Car'),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading:
                                                  Icon(Icons.directions_bus),
                                              title: Text('by Bus'),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading:
                                                  Icon(Icons.directions_train),
                                              title: Text('by Train'),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading:
                                                  Icon(Icons.directions_boat),
                                              title: Text('by Boat'),
                                            ),
                                          ),
                                          Card(
                                            child: ListTile(
                                              style: ListTileStyle.list,
                                              leading: Icon(Icons.flight),
                                              title: Text('by Plane'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.restaurant),
                              title: const Text('Food'),
                              onTap: () {},
                            ),
                          ),
                          Card(
                            child: ListTile(
                              leading: const Icon(Icons.tune),
                              title: const Text('Custom'),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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
