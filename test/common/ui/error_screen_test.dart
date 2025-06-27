import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/common/ui/error_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
      expect(find.text('Retry'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });
  });
}
