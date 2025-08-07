import 'package:appoint/features/personal_app/ui/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});

  group('SearchScreen', () {
    testWidgets('shows search field', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      // Wait for any async operations to complete
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
