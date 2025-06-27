import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/common/ui/empty_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
