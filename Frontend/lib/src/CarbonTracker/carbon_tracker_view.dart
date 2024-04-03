import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  const CarbonTrackerView({super.key});

  static const List<CarbonTrackItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        semanticChildCount: 2,
        slivers: <Widget>[
          const SliverAppBar(
            title: Text('Today'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Placeholder(
                  fallbackHeight: 150,
                ),
              ],
            ),
          ),
          // SliverList.builder(
          //   itemCount: 8,
          //   itemBuilder: (context, index) {
          //     ListTile(
          //       title: const Text('Car'),
          //       subtitle: Text(
          //           'At 15:38 - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
          //       trailing: const Text('42g'),
          //     );
          //   },
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Record action'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            showDragHandle: true,
            builder: (context) {
              return SizedBox(
                height: 200,
                child: ListView(
                  padding: const EdgeInsets.all(8.0),
                  children: <Widget>[
                    Card(
                      child: ListTile(
                        style: ListTileStyle.drawer,
                        leading: const Icon(Icons.explore),
                        title: const Text('Transport'),
                        onTap: () {
                          showModalBottomSheet(
                            constraints: BoxConstraints(maxHeight: 400),
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
                                        leading: Icon(Icons.directions_walk),
                                        title: Text('by Foot'),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Icon(Icons.directions_bike),
                                        title: Text('by Bicycle'),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Icon(Icons.directions_car),
                                        title: Text('by Car'),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Icon(Icons.directions_bus),
                                        title: Text('by Bus'),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Icon(Icons.directions_train),
                                        title: Text('by Train'),
                                      ),
                                    ),
                                    Card(
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: Icon(Icons.directions_boat),
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
