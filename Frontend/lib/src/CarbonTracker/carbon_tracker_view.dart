import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  const CarbonTrackerView({super.key});

  static const List<CarbonTrackItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            /*leading: const Card(
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.directions_car,
                  size: 34,
                ),
              ),
            ),*/
            title: const Text('Car'),
            subtitle: Text(
                'At 15:38 - ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
            trailing: const Text('42g'),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: 8,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Add task'),
        icon: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 200,
                child: ListView(
                  children: const <Widget>[
                    ListTile(
                      leading: Icon(Icons.explore),
                      title: Text('Transport'),
                    ),
                    ListTile(
                      leading: Icon(Icons.restaurant),
                      title: Text('Food'),
                    )
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
