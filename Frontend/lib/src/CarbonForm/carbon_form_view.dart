import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:carbon_footprint/src/CarbonForm/carbon_form_fetch.dart';
import 'package:flutter/material.dart';

class CarbonFormView extends StatefulWidget {
  const CarbonFormView({
    super.key,
  });

  @override
  State<CarbonFormView> createState() => _CarbonFormViewState();
}

class _CarbonFormViewState extends State<CarbonFormView> {
  late Future<CarbonForm> futureCarbonForm;

  @override
  void initState() {
    super.initState();
    futureCarbonForm = fetchCarbonForm();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<CarbonForm>(
        future: futureCarbonForm,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data!.title);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}

class CarbonFormWidget extends StatelessWidget {
  CarbonFormWidget({
    super.key,
    required this.carbonForm,
  });

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CarbonForm carbonForm;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: 1, 
        itemBuilder: (BuildContext context, int index) {
          return TextFormField(); 
          
        },
      ),
    );
  }
}
