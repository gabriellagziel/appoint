import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/components/common/empty_state.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('EmptyState', () {
    testWidgets('renders with default icon', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyState(title: 'No items'),
        ),
      );

      expect(find.text('No items'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('renders with custom icon', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyState(title: 'Empty', icon: Icons.error),
        ),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
    });
  });
}
