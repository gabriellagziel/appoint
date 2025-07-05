import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/common/ui/error_screen.dart';
import '../../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('ErrorScreen (features)', () {
    testWidgets('renders icon, message and try again button',
        (final tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ErrorScreen(
            message: 'Oops',
            onTryAgain: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Oops'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
