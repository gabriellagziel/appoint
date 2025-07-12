import 'package:appoint/common/ui/error_screen.dart';
import 'package:appoint/components/common/retry_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('ErrorScreen', () {
    testWidgets('renders with error message', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorScreen(
            message: 'Test error message',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Test error message'), findsOneWidget);
      expect(find.byType(RetryButton), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
    });
  });
}
