import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appoint/common/ui/error_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ErrorScreen', () {
    testWidgets('shows message and retry button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ErrorScreen(),
        ),
      );

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });
}
