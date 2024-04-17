import 'package:flutter/material.dart';

import 'Carbon_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';

class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});

  static final CarbonStatController _carbonController = CarbonStatController();

  @override
  Widget build(BuildContext context) {
    //  _carbonController.readStats().then(((value) {
    //     k = value.toString();
    //   }));
    //FIgure out how to go from Future<double> to String.
//(_carbonController.fetchStats(UserController().username)).toString()
    return FutureBuilder(
      future: _carbonController.fetchStats(UserController().username),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                String k = "hihe";
                k = snapshot.data!;
                return Placeholder(
                  fallbackHeight: 400,
                  child: Center(
                    child: Card(
                      child: Text(k),
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Text('error: ${snapshot.error.toString()}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
