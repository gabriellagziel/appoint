import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('should load English localization correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              late AppLocalizations l10n;
              l10n = AppLocalizations.of(context)!;
              return Scaffold(
                body: Column(
                  children: [
                    Text(l10n.adminBroadcast),
                    Text(l10n.noBroadcastMessages),
                    Text(l10n.contentLibrary),
                    Text(l10n.sendNow),
                    Text(l10n.details),
                    Text(l10n.composeBroadcastMessage),
                    Text(l10n.checkingPermissions),
                    Text(l10n.mediaOptional),
                    Text(l10n.pickImage),
                    Text(l10n.pickVideo),
                    Text(l10n.pollOptions),
                    Text(l10n.targetingFilters),
                    Text(l10n.scheduling),
                    Text(l10n.scheduleForLater),
                    Text(l10n.messageSavedSuccessfully),
                    Text(l10n.messageSentSuccessfully),
                    Text(l10n.close),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that all the key strings are loaded
      expect(find.text('Admin Broadcast'), findsOneWidget);
      expect(find.text('No broadcast messages'), findsOneWidget);
      expect(find.text('Content Library'), findsOneWidget);
      expect(find.text('Send Now'), findsOneWidget);
      expect(find.text('Details'), findsOneWidget);
      expect(find.text('Compose Broadcast Message'), findsOneWidget);
      expect(find.text('Checking permissions...'), findsOneWidget);
      expect(find.text('Media (Optional)'), findsOneWidget);
      expect(find.text('Pick Image'), findsOneWidget);
      expect(find.text('Pick Video'), findsOneWidget);
      expect(find.text('Poll Options'), findsOneWidget);
      expect(find.text('Targeting Filters'), findsOneWidget);
      expect(find.text('Scheduling'), findsOneWidget);
      expect(find.text('Schedule for Later'), findsOneWidget);
      expect(find.text('Message saved successfully'), findsOneWidget);
      expect(find.text('Message sent successfully'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('should handle method calls with parameters',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
          ],
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              late AppLocalizations l10n;
              l10n = AppLocalizations.of(context)!;
              return Scaffold(
                body: Column(
                  children: [
                    Text(l10n.type('Test Type')),
                    Text(l10n.content('Test Content')),
                    Text(l10n.status('Active')),
                    Text(l10n.recipients('5', 5)),
                    Text(l10n.opened(10)),
                    Text(l10n.created('2024-01-01', '2024-01-01')),
                    Text(l10n.scheduled('2024-01-02', '2024-01-02')),
                    Text(l10n.errorCheckingPermissions('Test Error')),
                    Text(l10n.errorSavingMessage('Test Error')),
                    Text(l10n.errorSendingMessage('Test Error')),
                    Text(l10n.link('https://example.com')),
                    Text(l10n.clicked('5', 5)),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that method calls with parameters work
      expect(find.text('Type: Test Type'), findsOneWidget);
      expect(find.text('Content: Test Content'), findsOneWidget);
      expect(find.text('Status: Active'), findsOneWidget);
      expect(find.text('Recipients: 5'), findsOneWidget);
      expect(find.text('Opened: 10'), findsOneWidget);
      expect(find.text('Created: 2024-01-01'), findsOneWidget);
      expect(find.text('Scheduled: 2024-01-02'), findsOneWidget);
      expect(
        find.text('Error checking permissions: Test Error'),
        findsOneWidget,
      );
      expect(find.text('Error saving message: Test Error'), findsOneWidget);
      expect(find.text('Error sending message: Test Error'), findsOneWidget);
      expect(find.text('Link: https://example.com'), findsOneWidget);
      expect(find.text('Clicked: 5'), findsOneWidget);
    });
  });
}
