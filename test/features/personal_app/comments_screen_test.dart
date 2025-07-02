import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appoint/features/personal_app/ui/comments_screen.dart';
import 'package:appoint/l10n/app_localizations.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();
  group('CommentsScreen', () {
    testWidgets('shows empty state when no comments',
        (final WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('en', 'US'),
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
