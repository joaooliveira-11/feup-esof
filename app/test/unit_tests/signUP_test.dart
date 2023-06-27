import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_explorer/screens/signUp_screen.dart';

void main() {
  late SignUpScreen signUpScreen;
  setUp(() {
    signUpScreen = const SignUpScreen();
  });

  group('Sign Up Unit Tests', () {
    testWidgets('Find Name TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signUpScreen));

      final nameTextField = find.widgetWithText(TextField, 'name');
      expect(nameTextField, findsOneWidget);
    });

    testWidgets('Find Username TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signUpScreen));

      final usernameTextField = find.widgetWithText(TextField, 'username');
      expect(usernameTextField, findsOneWidget);
    });

    testWidgets('Find Email TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signUpScreen));

      final emailTextField = find.widgetWithText(TextField, 'email');
      expect(emailTextField, findsOneWidget);
    });

    testWidgets('Find Password TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signUpScreen));

      final passwordTextField = find.widgetWithText(TextField, 'password');
      expect(passwordTextField, findsOneWidget);
    });

    testWidgets('Find Confirm Password TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signUpScreen));

      final confirmPasswordTextField = find.widgetWithText(
        TextField,
        'confirm password',
      );
      expect(confirmPasswordTextField, findsOneWidget);
    });

    testWidgets('Logo widget is visible', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      final logoImageFinder = find.byWidgetPredicate(
        (widget) =>
            widget is Image &&
            widget.image is AssetImage &&
            widget.fit == BoxFit.fitWidth &&
            widget.width == 240 &&
            widget.height == 240,
      );
      expect(logoImageFinder, findsOneWidget);
    });

    testWidgets('Sign In option is visible', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      final signInOption = find.text("Already have an account?");
      expect(signInOption, findsOneWidget);
    });

    testWidgets('Sign-up button is visible', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      final signUpButtonFinder = find.byWidgetPredicate(
        (widget) =>
            widget is ElevatedButton &&
            widget.child is Text &&
            (widget.child as Text).data == 'SIGN UP',
      );

      expect(signUpButtonFinder, findsOneWidget);
    });

    testWidgets('Sign In button is visible', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      final signInButtonFinder = find.byWidgetPredicate((widget) =>
          widget is GestureDetector &&
          widget.child is Text &&
          (widget.child as Text).data == ' Sign In');

      expect(signInButtonFinder, findsOneWidget);
    });
  });
}
