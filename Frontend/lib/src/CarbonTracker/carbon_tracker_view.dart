import 'package:carbon_footprint/src/CarbonTracker/carbon_tracker_controller.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:http/http.dart' as http;
import 'package:carbon_footprint/src/Settings/settings_controller.dart';
import 'dart:convert';
import 'package:carbon_footprint/src/user_controller.dart';

// written by Martin, // TODO
//
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
                int offset = 0;
                int indexOffset = 0;

                return ListView.builder(
                  itemBuilder: (context, index) {
                    if (offset >= snapshot.data!.length) {
                      return null;
                    }

                    final curItem = snapshot.data![count - offset];

                    indexOffset = offset;
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

                            if (index == 0 ||
                                (curItem.dateAdded.day ==
                                        lastItem.dateAdded.day &&
                                    curItem.dateAdded.month ==
                                        lastItem.dateAdded.month &&
                                    curItem.dateAdded.year ==
                                        lastItem.dateAdded.year)) {
                              offset++;
                              return ListTile(
                                leading: Icon(curItem.type.icon),
                                title: Text(curItem.type.text),
                                subtitle: Text(
                                    '${curItem.dateAdded.hour.toString().padLeft(2, '0')}:${curItem.dateAdded.minute.toString().padLeft(2, '0')} - ${curItem.dateAdded.day}/${curItem.dateAdded.month}/${curItem.dateAdded.year}'),
                                trailing: Text(curItem.carbonScore.toString()),
                                onTap: () {
                                  control.removeTrackerItem(curItem.id!);
                                },
                              );
                            }
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

  void addSavingItem(CarbonTackerType type, CarbonTrackerController control) {
    switch (type.name) {
      case 'meatFreeDay':
        http.Request request = http.Request(
            "PUT", Uri.parse('${SettingsController.address}/actionTracker'));
        request.body = jsonEncode(<String, String>{
          'name': type.name,
          'user': UserController().username,
          'type': 'carbonSaving',
          'score': '-10',
          'date': DateTime.now().toString(),
        });
        request.headers.addAll(<String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
        control.addTrackerItem(
          CarbonTrackerItem(
            type.name,
            type,
            -100, //random number, proof of concept for reduction of daily score.
            DateTime.now(),
          ),
        );

      case 'bikeToWork':
        control.addTrackerItem(
          CarbonTrackerItem(
            type.name,
            type,
            -50, //will be based on the carbon form data
            DateTime.now(),
          ),
        );

      default:
        control.addTrackerItem(
          CarbonTrackerItem(
            type.name,
            type,
            1,
            DateTime.now(),
          ),
        );
    }
  }
}

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
