import 'package:carbon_footprint/src/CarbonForm/Widgets/carbon_form_button.dart';
import 'package:flutter/material.dart';

class CarbonFormView extends StatelessWidget {
  const CarbonFormView({
    super.key,
  });

  static const routeName = '/carbonform';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return const Card(
            child: ListTile(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.request_page),
        onPressed: () {},
      ),
    );
  }
}
