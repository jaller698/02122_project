import 'package:carbon_footprint/src/CarbonForm/carbon_form_pending_controller.dart';
import 'package:flutter/material.dart';

// written by Martin,
// helper widget to main_view which is used to display badges for unanswered questionnaires

class FutureBadgeIconWidget extends StatelessWidget {
  const FutureBadgeIconWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future<int>(
        () async {
          return (await CarbonFormPendingController().carbonForm).id != '-1'
              ? 1
              : 0;
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data! > 0) {
            return const Badge(child: Icon(Icons.list_alt));
          }
        }
        return const Icon(Icons.list_alt);
      },
    );
  }
}
