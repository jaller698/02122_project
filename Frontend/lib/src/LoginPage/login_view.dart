import 'package:carbon_footprint/src/Views/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'sign_up_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

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
                  name: "userName",
                  decoration: const InputDecoration(labelText: 'User Name'),
                  textInputAction: TextInputAction.next,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: "userPassword",
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
                              Navigator.popAndPushNamed(
                                  context, MainView.routeName);
                            }
                          },
                          child: const Text('Login')),
                    ),
                  ],
                ),
                TextButton(
                    onPressed: () =>
                        Navigator.popAndPushNamed(context, MainView.routeName),
                    child: const Text('Continue as guest'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
