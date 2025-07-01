import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/components/common/retry_button.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('RetryButton', () {
    testWidgets('renders and triggers tap', (final tester) async {
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
