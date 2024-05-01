import 'package:carbon_footprint/src/CarbonForm/Widgets/carbon_form_button.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_controller.dart';
import 'package:flutter/material.dart';

class CarbonFormView extends StatelessWidget {
  const CarbonFormView({
    super.key,
  });

  static const routeName = '/carbonform';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: CarbonFormController(),
        builder: (context, child) {
          return FutureBuilder(
            future: CarbonFormController().carbonTrackerItems,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    return Card();
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
      floatingActionButton: const CarbonFormButton(),
    );
  }
}
