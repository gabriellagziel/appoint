import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/common/ui/empty_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
