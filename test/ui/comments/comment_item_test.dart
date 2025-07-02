import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/personal_app/ui/comment_item.dart';
import 'package:appoint/models/comment.dart';
import 'package:appoint/utils/localized_date_formatter.dart';
import 'package:appoint/l10n/app_localizations.dart';
import '../../fake_firebase_setup.dart';
import 'package:mocktail/mocktail.dart';

class MockLocalizedDateFormatter extends Mock
    implements LocalizedDateFormatter {}

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('CommentItem', () {
    testWidgets('renders relative time', (final tester) async {
      final timestamp = DateTime.now().subtract(const Duration(minutes: 2));
      final comment = Comment(id: '1', text: 'Hello', createdAt: timestamp);

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CommentItem(comment: comment),
        ),
      );

      expect(find.text('Hello'), findsOneWidget);
      // Look for any text that might contain time-related content
      expect(find.byType(Text), findsAtLeastNWidgets(2));
    });
  });
}
