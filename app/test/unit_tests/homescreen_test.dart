import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:porto_explorer/screens/home_screen.dart';
import 'package:porto_explorer/reusable_widgets/reusable_widget.dart';

void main() {
  testWidgets('Home screen - Recommended section', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final nameTextField = find.widgetWithText(TextField, 'name');
    expect(nameTextField, findsOneWidget);
  });
}
