import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/components/common/section_divider.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('SectionDivider', () {
    testWidgets('renders without label', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SectionDivider(),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders with label', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SectionDivider(label: 'Section'),
        ),
      );

      expect(find.text('Section'), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
    });
  });
}
