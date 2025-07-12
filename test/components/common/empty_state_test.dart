import 'package:appoint/components/common/empty_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('EmptyState', () {
    testWidgets('renders with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(title: 'No Items'),
          ),
        ),
      );

      expect(find.text('No Items'), findsOneWidget);
    });

    testWidgets('renders with custom description', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyState(
              title: 'No Items',
              description: 'Custom Description',
            ),
          ),
        ),
      );

      expect(find.text('Custom Description'), findsOneWidget);
    });
  });
}
