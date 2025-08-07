import 'package:appoint/components/common/section_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('SectionDivider', () {
    testWidgets('renders with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionDivider(),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders with custom label', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SectionDivider(label: 'Custom Label'),
          ),
        ),
      );

      expect(find.text('Custom Label'), findsOneWidget);
    });
  });
}
