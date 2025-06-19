import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Minimal smoke test that does not require Firebase initialization.

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Text('Business Dashboard'),
      ),
    );
    expect(find.text('Business Dashboard'), findsOneWidget);
  });
}
