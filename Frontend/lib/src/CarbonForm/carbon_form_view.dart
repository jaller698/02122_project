import 'package:carbon_footprint/src/CarbonForm/Widgets/carbon_form_button.dart';
import 'package:flutter/material.dart';

class CarbonFormView extends StatelessWidget {
  const CarbonFormView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CarbonFormButton(),
      ],
    );
  }
}
