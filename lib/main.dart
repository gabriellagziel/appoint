import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/config/routes.dart';
import 'package:appoint/providers/theme_provider.dart';
import 'package:appoint/firebase_options.dart';
import 'package:appoint/services/notification_service.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> appMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Enable Firestore offline persistence
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  // Enable Crashlytics collection
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  // Forward Flutter errors to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  // Forward Dart errors to Crashlytics
  FlutterError.onError = (final FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Initialize Firebase Analytics
  await analytics.setAnalyticsCollectionEnabled(true);

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runZonedGuarded(
    () {
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
    (final error, final stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

void main() {
  setUrlStrategy(const HashUrlStrategy());
  appMain();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({final Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'APP-OINT',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      navigatorKey: _navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      // Localization support
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('am'), // Amharic
        Locale('ar'), // Arabic
        Locale('bg'), // Bulgarian
        Locale('bn'), // Bengali
        Locale('cs'), // Czech
        Locale('da'), // Danish
        Locale('de'), // German
        Locale('el'), // Greek
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fa'), // Persian
        Locale('fi'), // Finnish
        Locale('fr'), // French
        Locale('gu'), // Gujarati
        Locale('ha'), // Hausa
        Locale('he'), // Hebrew
        Locale('hi'), // Hindi
        Locale('hr'), // Croatian
        Locale('hu'), // Hungarian
        Locale('id'), // Indonesian
        Locale('it'), // Italian
        Locale('ja'), // Japanese
        Locale('kn'), // Kannada
        Locale('ko'), // Korean
        Locale('lt'), // Lithuanian
        Locale('lv'), // Latvian
        Locale('mr'), // Marathi
        Locale('ms'), // Malay
        Locale('ne'), // Nepali
        Locale('nl'), // Dutch
        Locale('no'), // Norwegian
        Locale('pl'), // Polish
        Locale('pt'), // Portuguese
        Locale('ro'), // Romanian
        Locale('ru'), // Russian
        Locale('si'), // Sinhala
        Locale('sk'), // Slovak
        Locale('sl'), // Slovenian
        Locale('sr'), // Serbian
        Locale('sv'), // Swedish
        Locale('sw'), // Swahili
        Locale('ta'), // Tamil
        Locale('th'), // Thai
        Locale('tl'), // Tagalog
        Locale('tr'), // Turkish
        Locale('uk'), // Ukrainian
        Locale('ur'), // Urdu
        Locale('vi'), // Vietnamese
        Locale('zh'), // Chinese (Simplified)
        Locale('zh', 'Hant'), // Chinese (Traditional)
        Locale('zu'), // Zulu
      ],
    );
  }
}
