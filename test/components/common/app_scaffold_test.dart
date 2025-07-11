import 'package:appoint/components/common/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('AppScaffold', () {
    testWidgets('renders with title and child', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            title: 'Test Title',
            child: Text('Test Body'),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Body'), findsOneWidget);
    });

    testWidgets('renders with child only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            child: Text('Test Body'),
          ),
        ),
      );

      expect(find.text('Test Body'), findsOneWidget);
    });
  });
}
