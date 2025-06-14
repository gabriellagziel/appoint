import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:appoint/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Business Dashboard'), findsOneWidget);
  });
}
