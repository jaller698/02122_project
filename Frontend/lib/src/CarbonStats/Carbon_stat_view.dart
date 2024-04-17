import 'package:flutter/material.dart';

import 'Carbon_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';

class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});

  static const routeName = '/carbonstats';

  static final CarbonStatController _carbonController = CarbonStatController();

  Future<List<String>> toList(String Comp) async {
    Future<List<String>> fut = Future(()async => [await _carbonController.fetchStats(UserController().username),await _carbonController.fetchStats(Comp)] );
    return fut;
  }

  @override
  Widget build(BuildContext context) {
    //  _carbonController.readStats().then(((value) {
    //     k = value.toString();
    //   }));
    //FIgure out how to go from Future<double> to String.
//(_carbonController.fetchStats(UserController().username)).toString()
    var fut = toList("guest");

    return FutureBuilder(
      future: fut,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                String k = snapshot.data![0];
                String k2 = snapshot.data![1];
                return Placeholder(
                  fallbackHeight: 400,
                  child: Center(
                    child: Card(
                      child: Text(k + " compared to " + k2),
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          print("2");
          return Center(child: Text('error: ${snapshot.error.toString()}'));
        } else {
          print("3");
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
