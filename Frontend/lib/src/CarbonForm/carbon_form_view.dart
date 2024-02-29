import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class CarbonFormView extends StatefulWidget {
  CarbonFormView({super.key, required carbonForm})
      : _carbonForm = CarbonForm.fromJson(carbonForm);

  static const routeName = '/Carbon_Form';

  final CarbonForm _carbonForm;

  @override
  State<CarbonFormView> createState() => _CarbonFormViewState();
}

class _CarbonFormViewState extends State<CarbonFormView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._carbonForm.title),
      ),
      body: FormBuilder(
        key: _formKey,
        child: ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: widget._carbonForm.questions.length,
          itemBuilder: (context, index) {
            var _question = widget._carbonForm.questions[index];

            switch (_question.type) {
              // TODO
              case CarbonQuestionType.arbitrary:
              case CarbonQuestionType.date:
              case CarbonQuestionType.dateTime:
              case CarbonQuestionType.float:
              case CarbonQuestionType.int:
              case CarbonQuestionType.string:
              case CarbonQuestionType.time:
              default:
                return FormBuilderTextField(
                  name: _question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(),
                );
            }
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 16,
              indent: 8,
              endIndent: 8,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Submit'),
        icon: const Icon(Icons.check),
        onPressed: () {
          if (_formKey.currentState!.saveAndValidate()) {
            debugPrint(_formKey.currentState?.value.toString());
          }
        },
      ),
    );
  }
}
