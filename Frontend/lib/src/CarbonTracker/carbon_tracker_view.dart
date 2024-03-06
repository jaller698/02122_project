import 'package:flutter/material.dart';

class CarbonTrackerView extends StatelessWidget {
  const CarbonTrackerView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
        return Divider();
      },
      itemCount: 8,
    );
  }
}
