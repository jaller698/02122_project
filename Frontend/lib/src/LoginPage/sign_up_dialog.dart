import 'package:carbon_footprint/src/LoginPage/http/create_new_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// written by Martin,
// pop up dialog for account creation or a user sign up
class SignUpDialog extends StatefulWidget {
  const SignUpDialog({super.key});

  @override
  State<SignUpDialog> createState() => _SignUpDialogState();
}

class _SignUpDialogState extends State<SignUpDialog> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Dialog.fullscreen(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  name: 'username',
                  decoration: const InputDecoration(labelText: 'User name'),
                  validator: FormBuilderValidators.required(),
                ),
                FormBuilderTextField(
                  name: 'password',
                  obscureText: obscurePassword,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.minLength(6),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'confirmPassword',
                  obscureText: obscurePassword,
                  decoration:
                      const InputDecoration(labelText: 'Confirm password'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      _formKey.currentState?.fields['password']?.value != value
                          ? 'No match'
                          : null,
                ),
                FormBuilderCheckbox(
                  name: 'termsAndConditions',
                  title: const Text.rich(
                    TextSpan(
                      text: 'I have read and accept the ',
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Terms of Service',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' and ', children: <TextSpan>[
                          TextSpan(
                            text: 'Privacy Policy',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          )
                        ])
                      ],
                    ),
                  ),
                  validator: FormBuilderValidators.required(),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState?.saveAndValidate() ??
                              false) {
                            Future<bool> futureSession = createNewUser(
                                _formKey.currentState!.value['username']
                                    as String,
                                _formKey.currentState!.value['password']
                                    as String);
                            futureSession.then((value) {
                              if (value) {
                                Navigator.pop(context, true);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Sign up failed'),
                                    content: const Text('User already exists'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: const Text('Sign up'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
