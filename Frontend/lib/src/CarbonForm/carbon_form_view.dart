import 'package:carbon_footprint/src/CarbonForm/carbon_form_button.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_history_controller.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_pending_controller.dart';
import 'package:flutter/material.dart';

import 'Modals/carbon_form.dart';
import 'Modals/carbon_form_answer.dart';
import 'carbon_form_questionnaire.dart';

class CarbonFormView extends StatelessWidget {
  const CarbonFormView({
    super.key,
  });

  static const routeName = '/carbonform';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // new loaded form
          ListenableBuilder(
            listenable: CarbonFormPendingController(),
            builder: (context, child) {
              return FutureBuilder(
                future: CarbonFormPendingController().carbonForm,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.id != '-1') {
                      return Card(
                        child: ListTile(
                          title: Text(snapshot.data!.title),
                          subtitle: Text(snapshot.data!.id),
                          onTap: () {
                            Navigator.restorablePushNamed(
                                context, CarbonFormQuestionnaire.routeName,
                                arguments: CarbonForm.toMap(snapshot.data!));
                          },
                        ),
                      );
                    }
                    return Container();
                  } else if (snapshot.hasError) {
                    return Text('error: ${snapshot.error.toString()}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
          const Divider(),
          // history of form answers
          ListenableBuilder(
            listenable: CarbonFormHistoryController(),
            builder: (context, child) {
              return FutureBuilder(
                future: CarbonFormHistoryController().carbonForms,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            title: Text(snapshot.data![index].title),
                            subtitle: Text(snapshot.data![index].id),
                            leading: Text(index.toString()),
                            onTap: () {
                              // TODO view old forms

                              Navigator.restorablePushNamed(
                                  context, CarbonFormQuestionnaire.routeName,
                                  arguments: CarbonFormAnswer.toMap(
                                      snapshot.data![index]));
                            },
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('error: ${snapshot.error.toString()}');
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: const CarbonFormButton(),
    );
  }
}
