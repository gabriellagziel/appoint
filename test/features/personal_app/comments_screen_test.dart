import 'package:appoint/features/personal_app/ui/comments_screen.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'firebase_test_helper.dart';

void main() {
  setUpAll(() async {});
  group('CommentsScreen', () {
    testWidgets('shows empty state when no comments',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: CommentsScreen(),
        ),
      );

      expect(find.text('Comments'), findsOneWidget);
      expect(find.text('No comments yet'), findsOneWidget);
      expect(find.text('Be the first to leave a comment!'), findsOneWidget);
    });
  });
}
