import 'package:carbon_footprint/src/LoginPage/http/get_user_session.dart';
import 'package:carbon_footprint/src/main_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:carbon_footprint/src/user_controller.dart';

import 'sign_up_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  static const routeName = '/LoginPage';
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  name: "username",
                  decoration: const InputDecoration(labelText: 'Username'),
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: "password",
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () {
                            Future<bool?> futureSignup = showDialog<bool?>(
                              context: context,
                              builder: (context) => const SignUpDialog(),
                            );

                            futureSignup.then((value) {
                              if (value ?? false) {
                                Navigator.popAndPushNamed(
                                    context, MainView.routeName);
                              }
                            });
                          },
                          child: const Text('Sign up')),
                    ),
                    Expanded(
                      child: FilledButton(
                          onPressed: () {
                            if (_formKey.currentState?.saveAndValidate() ??
                                false) {
                              Future<bool> futureSession = getUserSession(
                                  _formKey.currentState!.value['username']
                                      as String,
                                  _formKey.currentState!.value['password']
                                      as String);
                              futureSession.then((value) {
                                if (value) {
                                  Navigator.popAndPushNamed(
                                      context, MainView.routeName);
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text('Login failed'),
                                            content: const Text(
                                                'Invalid username or password'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('OK'),
                                              ),
                                            ],
                                          ));
                                }
                              });
                            }
                          },
                          child: const Text('Login')),
                    ),
                  ],
                ),
                kDebugMode ? TextButton(
                    onPressed: () => {
                        UserController().username = "guest",
                        UserController().carbonScore = -1,
                        Navigator.popAndPushNamed(context, MainView.routeName)
                    },
                    child: const Text('Continue as guest')) : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
