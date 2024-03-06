import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  const CarbonTrackerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemBuilder: (context, index) {
          return Placeholder(
            fallbackHeight: 100,
            child: Center(
              child: Card(
                child: Text('task - $index'),
              ),
            ),
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
          showLicensePage(context: context);
        },
      ),
    );
  }
}
