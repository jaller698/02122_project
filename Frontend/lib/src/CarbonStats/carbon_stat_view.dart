import 'package:carbon_footprint/src/user_controller.dart';
import 'package:flutter/widgets.dart';

import 'carbon_history_view.dart';
import 'Comparison_stat_view.dart';

class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          // const Text(
          //   'Carbon Stats',
          //   style: TextStyle(
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          const Expanded(
            child: ComparisonStatView(),
          ),
          const Text(
            'Carbon score history',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          UserController().username == 'guest'
              ? Container()
              : const CarbonHistoryView()
        ],
      ),
    );
  }
}
