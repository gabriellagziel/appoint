import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:appoint/common/ui/empty_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EmptyScreen', () {
    testWidgets('shows placeholder and explore button', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: EmptyScreen(),
        ),
      );

      expect(find.text('Nothing here yet'), findsOneWidget);
      expect(find.text('Explore'), findsOneWidget);
    });
  });
}
