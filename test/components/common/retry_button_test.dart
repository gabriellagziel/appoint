import 'package:appoint/components/common/retry_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('RetryButton', () {
    testWidgets('renders and triggers tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: RetryButton(onPressed: () => tapped = true),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });
}
