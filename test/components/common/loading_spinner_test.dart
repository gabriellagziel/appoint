import 'package:appoint/components/common/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('LoadingSpinner', () {
    testWidgets('renders with default properties', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingSpinner(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders with custom text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingSpinner(text: 'Custom Loading...'),
        ),
      );

      expect(find.text('Custom Loading...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
