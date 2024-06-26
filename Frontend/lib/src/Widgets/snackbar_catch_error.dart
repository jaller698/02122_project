import 'package:flutter/material.dart';

// written by Martin,
// helper widget used to display errors in a snackbar and possible fullscreen popup if desired

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> SnackBarCatchError(
    BuildContext context, error) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("ERROR: $error", softWrap: false),
      showCloseIcon: true,
      duration: const Duration(seconds: 30),
      action: SnackBarAction(
        label: "Details",
        onPressed: () => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Error"),
            content: SingleChildScrollView(
              child: Text("ERROR: $error"),
            ),
            actions: [
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
