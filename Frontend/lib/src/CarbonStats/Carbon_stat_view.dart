import 'package:flutter/material.dart';

import 'package:primer_progress_bar/primer_progress_bar.dart';

import 'Carbon_stat_controller.dart';
import 'package:carbon_footprint/src/user_controller.dart';
class CarbonStatView extends StatelessWidget {
  const CarbonStatView({super.key});
  

  static List<Segment> segments = [
    const Segment(value: 29, color: Colors.purple, label: Text("Transport")),
    const Segment(value: 20, color: Colors.deepOrange, label: Text("Home")),
    const Segment(value: 18, color: Colors.lime, label: Text("Food")),
    const Segment(value: 33, color: Colors.green, label: Text("Other")),
  ];

  @override
  static final CarbonStatController _carbonController = CarbonStatController();

  @override
  Widget build(BuildContext context) { 
    
    String k = "hihe";
  //  _carbonController.readStats().then(((value) {
  //     k = value.toString();
  //   }));
    //FIgure out how to go from Future<double> to String.
   
     k = _carbonController.fetchStats( UserController().username).toString();
    return ListView(
      children:  <Widget>[
       Placeholder(
        fallbackHeight: 400,
        child: Center(
          child: Card(
            child: Text(k),
          ),
        ),


      ),
    ]);
  }
}
