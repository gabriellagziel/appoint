import 'package:appoint/common/ui/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('ErrorScreen', () {
    testWidgets('shows icon, message and retry button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorScreen(
            message: 'Failed',
            onRetry: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
