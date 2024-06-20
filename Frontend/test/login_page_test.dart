import 'package:carbon_footprint/src/LoginPage/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // login view
  testWidgets('Login view test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LoginView());

    await tester.enterText(find.text('Username'), 'unknown user123');
    await tester.enterText(find.text('Password'), 'unknown password123');

    tester.tap(find.text('Login'));

    await tester.pump();

    await expectLater(find.byWidget(const Dialog()), findsOne);
  });
}
