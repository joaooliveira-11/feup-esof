import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_explorer/screens/signIn_screen.dart';

void main() {
  late SignInScreen signInScreen;

  setUp(() {
    signInScreen = const SignInScreen();
  });

  group('Sign In Unit Tests', () {
    testWidgets('Find Email TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signInScreen));

      final emailTextField = find.widgetWithText(TextField, 'email');
      expect(emailTextField, findsOneWidget);
    });

    testWidgets('Find Password TextField', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signInScreen));

      final passwordTextField = find.widgetWithText(TextField, 'password');
      expect(passwordTextField, findsOneWidget);
    });

    testWidgets('Logo widget is visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signInScreen));

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

    testWidgets('Sign Up option is visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signInScreen));

      final signUpOption = find.text("Don't have account?");
      expect(signUpOption, findsOneWidget);
    });

    testWidgets('Sign In button is visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signInScreen));

      final signInButtonFinder = find.byWidgetPredicate((widget) =>
          widget is ElevatedButton &&
          widget.child is Text &&
          (widget.child as Text).data == 'LOG IN');

      expect(signInButtonFinder, findsOneWidget);
    });

    testWidgets('Sign Up button is visible', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: signInScreen));

      final signUpButtonFinder = find.byWidgetPredicate((widget) =>
          widget is GestureDetector &&
          widget.child is Text &&
          (widget.child as Text).data == ' Sign Up');

      expect(signUpButtonFinder, findsOneWidget);
    });
  });
}
