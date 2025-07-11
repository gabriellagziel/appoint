import 'package:appoint/common/ui/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('EmptyScreen', () {
    testWidgets('shows subtitle and action button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EmptyScreen(
            subtitle: 'Nothing here',
            actionLabel: 'Add',
            onAction: () {},
          ),
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
