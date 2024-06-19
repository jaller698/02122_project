import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'dart:convert';
import 'package:carbon_footprint/src/user_controller.dart';

// written by Martin, 
// widget to display history of all items the user has logged
class CarbonTrackerView extends StatelessWidget {
  CarbonTrackerView({super.key});

  static const routeName = '/carbontracker';

  final CarbonTrackerController control = CarbonTrackerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // to update if the controller changes
      body: ListenableBuilder(
        listenable: CarbonTrackerController(),
        builder: (context, child) {
          // to update only when its future is completed
          return FutureBuilder(
            future: control.carbonTrackerItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final count = snapshot.data!.length - 1;
                // offset to determin the current item to display, as this widgets nature as a nested listView,
                // makes the index variable unrealiable to determin the next item
                int offset = 0;

                // base list widget generate a list of widgets which displays a given day followed by another
                // list widget of all item in the given day
                return ListView.builder(
                  itemBuilder: (context, index) {
                    if (offset >= snapshot.data!.length) {
                      return null;
                    }

                    final curItem = snapshot.data![count - offset];

                    // set an unchanging offset to be incremeted by an index
                    int indexOffset = offset;
                    return Column(
                      children: [
                        Text(
                            '${curItem.dateAdded.day}/${curItem.dateAdded.month}/${curItem.dateAdded.year}'),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemBuilder: (context, index) {
                            int indexAdditive = index + indexOffset;
                            if (count - indexAdditive < 0) {
                              return null;
                            }
                            final curItem =
                                snapshot.data![count - indexAdditive];
                            final lastItem = snapshot.data![index == 0
                                ? count - indexAdditive
                                : count - indexAdditive + 1];

                            // logic to check if the current widget is still within the save day
                            if (index == 0 ||
                                (curItem.dateAdded.day ==
                                        lastItem.dateAdded.day &&
                                    curItem.dateAdded.month ==
                                        lastItem.dateAdded.month &&
                                    curItem.dateAdded.year ==
                                        lastItem.dateAdded.year)) {
                              offset++;
                              // create widget
                              return ListTile(
                                leading: Icon(curItem.type.icon),
                                title: Text(curItem.type.text),
                                subtitle: Text(
                                    '${curItem.dateAdded.hour.toString().padLeft(2, '0')}:${curItem.dateAdded.minute.toString().padLeft(2, '0')}'),
                                trailing: Text(curItem.carbonScore.toString()),
                                onTap: () {
                                  control.removeTrackerItem(curItem.id!);
                                },
                              );
                            }
                            // otherwise return null and stop current list builder
                            return null;
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('error: ${snapshot.error.toString()}');
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        },
      ),
      // floating button with both a tap and long press actions
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

  // written by Martin,
  // show a bottom sheet to display all categories in which an item can be added
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
              height: 300,
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
                        showCarbonItemList(context, singleAction, category);
                      },
                      onLongPress: () {
                        singleAction = false;
                        showCarbonItemList(context, singleAction, category);
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

  // written by Martin,
  // widget to show a list buttons for all item that can be added in the given category
  void showCarbonItemList(
      BuildContext context, bool singleAction, CarbonTrackerCategory category) {
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
                      switch (type.type) {
                        case CarbonTrackInputTypes.time:
                        case CarbonTrackInputTypes.distance:
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: TrackerInputDistance(
                                    type: type,
                                    control: control,
                                    singleAction: singleAction),
                              );
                            },
                          );
                        case CarbonTrackInputTypes.single:
                        case CarbonTrackInputTypes.custom:
                        case CarbonTrackInputTypes.carbonSaving:
                          addSavingItem(type, control);
                        default:
                          control.addTrackerItem(
                            CarbonTrackerItem(
                              type.name,
                              type,
                              1,
                              DateTime.now(),
                            ),
                          );
                          if (singleAction) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      );
    }
  }

  // written by Natascha
  void addSavingItem(CarbonTackerType type, CarbonTrackerController control) {
    /* 
    * The switch case seems overkill but it is to make it easier to update later.
    * I expect that the carbon saving actions could require some more complicated calculations than the other categories
    * If a certain action requires certain information or calcs,
    * it would be easy to implement it by creating another case
    */
    switch (type.name) {
      case 'meatFreeDay':
        control.addTrackerItem(
          CarbonTrackerItem(
            type.name,
            type,
            -10, //random number, proof of concept for reduction of daily score.
            DateTime.now(),
          ),
        );

      case 'bikeToWork':
        control.addTrackerItem(
          CarbonTrackerItem(
            type.name,
            type,
            -20, //placeholder number, but could be updated to be based on the distance driven in a week
            DateTime.now(),
          ),
        );

      default:
        control.addTrackerItem(
          CarbonTrackerItem(
            type.name,
            type,
            -1,
            DateTime.now(),
          ),
        );
    }
  }
}

// written by Martin,
// stateless part of stateful widget, contains route name
class TrackerInputDistance extends StatefulWidget {
  const TrackerInputDistance({
    super.key,
    required this.type,
    required this.control,
    required this.singleAction,
  });

  final CarbonTackerType type;
  final CarbonTrackerController control;
  final bool singleAction;

  @override
  State<TrackerInputDistance> createState() => _TrackerInputDistanceState();
}

// written by Martin,
// helper widget to input distances
class _TrackerInputDistanceState extends State<TrackerInputDistance> {
  int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: NumberPicker(
            minValue: 0,
            maxValue: 100,
            value: _currentValue,
            onChanged: (value) {
              setState(() => _currentValue = value);
            },
            haptics: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () {
              widget.control.addTrackerItem(
                CarbonTrackerItem(
                  widget.type.name,
                  widget.type,
                  _currentValue,
                  DateTime.now(),
                ),
              );
              if (widget.singleAction) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              }
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Text('Confirm'),
            ),
          ),
        )
      ],
    );
  }
}
