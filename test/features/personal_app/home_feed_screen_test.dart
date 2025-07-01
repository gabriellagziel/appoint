import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/home_feed_screen.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('HomeFeedScreen', () {
    testWidgets('shows placeholder feed text', (final tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeFeedScreen()));

      expect(find.text('Home Feed Screen'), findsOneWidget);
    });
  });
}
