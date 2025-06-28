import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/components/common/loading_spinner.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('LoadingSpinner', () {
    testWidgets('shows default text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingSpinner(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('shows custom text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: LoadingSpinner(text: 'Please wait'),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Please wait'), findsOneWidget);
    });
  });
}
