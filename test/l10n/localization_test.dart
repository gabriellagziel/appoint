import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Localization Tests', () {
    testWidgets('should load English localization correctly',
        (WidgetTester tester) async {
      AppLocalizations? l10n;
      
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
              l10n = AppLocalizations.of(context);
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that localization is available
      expect(l10n, isNotNull);
      
      // Verify that basic keys are accessible
      expect(l10n!.refresh, 'Refresh');
      expect(l10n!.home, 'Home');
      expect(l10n!.ok, 'OK');
      
      // Verify that newly added keys are accessible
      expect(l10n!.welcomeAmbassador, 'Welcome, Ambassador!');
      expect(l10n!.activeStatus, 'Active');
      expect(l10n!.totalReferrals, 'Total Referrals');
    });

    testWidgets('should load Hebrew localization correctly',
        (WidgetTester tester) async {
      AppLocalizations? l10n;
      
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('he'),
          ],
          locale: const Locale('he'),
          home: Builder(
            builder: (context) {
              l10n = AppLocalizations.of(context);
              return const Scaffold(
                body: Text('Test'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that Hebrew localization is available
      expect(l10n, isNotNull);
      
      // For Hebrew, check actual Hebrew translations
      expect(l10n!.refresh, 'רענן');
      expect(l10n!.welcomeAmbassador, 'Welcome Ambassador'); // Hebrew ARB value
    });
  });
}
