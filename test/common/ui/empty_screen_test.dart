import 'package:appoint/common/ui/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('EmptyScreen', () {
    testWidgets('shows placeholder text and explore button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EmptyScreen(
            onExplore: () {},
          ),
        ),
      );

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
