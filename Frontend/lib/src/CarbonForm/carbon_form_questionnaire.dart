import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form.dart';
import 'package:carbon_footprint/src/CarbonForm/Modals/carbon_form_answer.dart';
import 'package:carbon_footprint/src/Widgets/snackbar_catch_error.dart';
import 'package:carbon_footprint/src/CarbonForm/http/carbon_form_send.dart';
import 'package:carbon_footprint/src/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// written by Martin,
// stateless part of stateful widget, contains route name and the specific form to show
class CarbonFormQuestionnaire extends StatefulWidget {
  CarbonFormQuestionnaire({super.key, required carbonForm})
      : _carbonForm = CarbonForm.fromMap(carbonForm);

  static const routeName = 'carbonform/questionnaire';

  final CarbonForm _carbonForm;

  @override
  State<CarbonFormQuestionnaire> createState() =>
      _CarbonFormQuestionnaireState();
}

// written by Martin,
// widget which allows the user to answer forms
class _CarbonFormQuestionnaireState extends State<CarbonFormQuestionnaire> {
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
            var question = widget._carbonForm.questions[index];

            // input widget for all supported input types
            switch (question.type) {
              case CarbonQuestionType.int:
                return FormBuilderTextField(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                    hintMaxLines: 5,
                    helperText: 'Accepts numbers',
                  ),
                  maxLines: 5,
                  minLines: 1,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.integer(),
                );
              case CarbonQuestionType.float:
                return FormBuilderTextField(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.numeric(),
                );
              case CarbonQuestionType.date:
                return FormBuilderDateTimePicker(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                  inputType: InputType.date,
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(),
                );
              case CarbonQuestionType.dateTime:
                return FormBuilderDateTimePicker(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                  inputType: InputType.both,
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(),
                );
              case CarbonQuestionType.time:
                return FormBuilderDateTimePicker(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                  inputType: InputType.time,
                  keyboardType: TextInputType.number,
                  validator: FormBuilderValidators.required(),
                );
              case CarbonQuestionType.dateRange:
                return FormBuilderDateRangePicker(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                  firstDate: DateTime(DateTime.now().year - 30),
                  lastDate: DateTime(DateTime.now().year + 200),
                  keyboardType: TextInputType.datetime,
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.required(),
                );
              case CarbonQuestionType.checkBox:
                return FormBuilderCheckbox(
                  name: question.title,
                  title: Text(question.type.name),
                  validator: FormBuilderValidators.required(),
                );
              case CarbonQuestionType.dropDown:
                return FormBuilderDropdown(
                  name: question.title,
                  items: [],
                );
              case CarbonQuestionType.slider:
                return FormBuilderSlider(
                  name: question.title,
                  initialValue: 0,
                  min: 0,
                  max: 100,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                  ),
                );
              case CarbonQuestionType.arbitrary:
              case CarbonQuestionType.string:
              default:
                return FormBuilderTextField(
                  name: question.title,
                  decoration: InputDecoration(
                    labelText: widget._carbonForm.questions[index].title,
                    hintText: widget._carbonForm.questions[index].type.name,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
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
          // form validator, to check if the user has not managed to type letters into a numbers only field or similar
          if (_formKey.currentState!.saveAndValidate()) {
            // send the now completed carbon form to the server
            Future<void> future = sendCarbonForm(CarbonFormAnswer(
                title: widget._carbonForm.title,
                user: UserController().username,
                anwsers: _formKey.currentState!.value));

            // catch error in case of failure and display it in the snackbar
            future.then((value) => Navigator.pop(context)).catchError((error) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              SnackBarCatchError(context, error);
            });
          }
        },
      ),
    );
  }
}
