import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_pending_controller.dart';
import 'package:carbon_footprint/src/Widgets/snackbar_catch_error.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_questionnaire.dart';
import 'package:flutter/material.dart';

import 'http/carbon_form_fetch.dart';

// written by Martin, // TODO
//
class CarbonFormButton extends StatefulWidget {
  const CarbonFormButton({
    super.key,
  });

  @override
  State<CarbonFormButton> createState() => _CarbonFormButtonState();
}

class _CarbonFormButtonState extends State<CarbonFormButton> {
  bool awatingData = false;

  @override
  Widget build(BuildContext context) {
    return [
      FloatingActionButton(
        onPressed: () {
          // request form data from server
          Future<CarbonForm> futureCarbonForm = fetchCarbonForm();
          setState(() => awatingData = true);

          // give feedback to user
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("requesting form..."), showCloseIcon: true));

          futureCarbonForm.then((value) {
            setState(() => awatingData = false);

            CarbonFormPendingController().saveForm(value);

            Navigator.restorablePushNamed(
                context, CarbonFormQuestionnaire.routeName,
                arguments: CarbonForm.toMap(value));
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }).catchError((error) {
            setState(() => awatingData = false);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            SnackBarCatchError(context, error);
          });
        },
        child: const Icon(Icons.cloud_download),
      ),
      FloatingActionButton(
        onPressed: () {},
        child: const CircularProgressIndicator.adaptive(),
      ),
    ][awatingData ? 1 : 0];
  }
}
