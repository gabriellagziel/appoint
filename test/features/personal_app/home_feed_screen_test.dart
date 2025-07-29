import 'package:appoint/features/personal_app/home_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});

  group('HomeFeedScreen', () {
    testWidgets('shows placeholder feed text', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeFeedScreen()));

      expect(find.text('Home Feed Screen'), findsOneWidget);
    });
  });
}
