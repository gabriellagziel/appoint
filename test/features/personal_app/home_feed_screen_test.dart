import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/home_feed_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeFeedScreen', () {
    testWidgets('displays default feed content', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeFeedScreen()));

      expect(find.text('Home Feed Screen'), findsOneWidget);
    });
  });
}
