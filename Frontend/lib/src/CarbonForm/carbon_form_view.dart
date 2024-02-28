import 'package:carbon_footprint/src/CarbonForm/carbon_form.dart';
import 'package:flutter/material.dart';

class CarbonFormView extends StatefulWidget {
  CarbonFormView({super.key, required carbonForm})
      : _carbonForm = CarbonForm.fromJson(carbonForm);

  static const routeName = '/Carbon_Form';

  final CarbonForm _carbonForm;

  @override
  State<CarbonFormView> createState() => _CarbonFormViewState();
}

class _CarbonFormViewState extends State<CarbonFormView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget._carbonForm.questions.length,
          itemBuilder: (context, index) {
            return TextFormField(
              decoration: InputDecoration(
                labelText: widget._carbonForm.questions[index].title,
                hintText: widget._carbonForm.questions[index].type.name,
                border: const OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {},
            );
          },
        ),
      ),
    );
  }
}
