import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'l10n/app_localizations.dart';
import 'config/routes.dart';
import 'config/theme.dart';
import 'firebase_options.dart';
import 'services/custom_deep_link_service.dart';
import 'services/notification_service.dart';

Future<void> appMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase Analytics
  await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);

  // Initialize Firebase Remote Config
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setDefaults(const {
    'welcome_message': 'Hello from Remote Config',
    'show_ads': false,
  });
  await remoteConfig.fetchAndActivate();

  // Initialize custom deep link service (replaces Firebase Dynamic Links)
  final deepLinkService = CustomDeepLinkService();
  // Deep link initialization is disabled to avoid unsupported web URL errors
  // during tests and web builds.
  // await deepLinkService.initialize();

  // Initialize notifications
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      child: MyApp(deepLinkService: deepLinkService),
    ),
  );
}

void main() {
  appMain();
}

class MyApp extends StatefulWidget {
  final CustomDeepLinkService deepLinkService;

  const MyApp({Key? key, required this.deepLinkService}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Set the navigator key for deep link service
    widget.deepLinkService.setNavigatorKey(_navigatorKey);
  }

  @override
  void dispose() {
    widget.deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP-OINT',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      navigatorKey: _navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      // Localization support
      localizationsDelegates: [
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
