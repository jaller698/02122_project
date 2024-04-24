import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_controller.dart';
import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  CarbonTrackerView({super.key});

  static const routeName = '/carbontracker';

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
                      title: Text(item.type.text),
                      subtitle: Text(
                          '${item.dateAdded.hour}:${item.dateAdded.second}'),
                      trailing: Text(item.carbonScore.toString()),
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
      floatingActionButton: InkWell(
        onLongPress: () {
          // long press to select multiple items
          bool singleAction = false;
          showAddCarbonItem(context, singleAction);
        },
        child: FloatingActionButton.extended(
          label: const Text('Record action'),
          icon: const Icon(Icons.add),
          onPressed: () {
            // for single items
            bool singleAction = true;
            showAddCarbonItem(context, singleAction);
          },
        ),
      ),
    );
  }

  Future<void> showAddCarbonItem(BuildContext context, bool singleAction) {
    return showModalBottomSheet<void>(
      constraints: const BoxConstraints(maxHeight: 400),
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Long press to add multiple',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            SizedBox(
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
                        // if single item
                        if (category.types.length == 1) {
                          control.addTrackerItem(
                            CarbonTrackerItem(
                              category.types[0].name,
                              category.types[0],
                              4000,
                              DateTime.now(),
                            ),
                          );
                          if (singleAction) {
                            Navigator.pop(context);
                          }
                        } else if (category.types.isNotEmpty) {
                          showModalBottomSheet(
                            constraints: const BoxConstraints(maxHeight: 400),
                            context: context,
                            showDragHandle: true,
                            isScrollControlled: true,
                            builder: (context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'Long press for additional options',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic),
                                  ),
                                  SizedBox(
                                    height: 335,
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
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) {
                                                  return SizedBox(
                                                    height: 200,
                                                  );
                                                },
                                              );

                                              //control.addTrackerItem(CarbonTrackerItem(type.name,type,4000,DateTime.now(),),);
                                              if (singleAction) {
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              }
                                            },
                                            onLongPress: () {},
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
