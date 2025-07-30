import 'dart:async';

import 'package:appoint/config/app_router.dart';
import 'package:appoint/config/routes.dart';
import 'package:appoint/firebase_options.dart';
import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/providers/theme_provider.dart';
import 'package:appoint/services/api/api_client.dart';
import 'package:appoint/services/analytics/analytics_service.dart';
import 'package:appoint/services/notifications/push_notification_service.dart';
import 'package:appoint/services/error/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/firebase_options_dev.dart' as dev;
import 'package:appoint/firebase_options_prod.dart' as prod;

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> appMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

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
  FlutterError.onError = (FlutterErrorDetails details) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Initialize Firebase Analytics
  await analytics.setAnalyticsCollectionEnabled(true);

  // Initialize notifications
  // notificationService = NotificationService();
  // await notificationService.initialize();

  runZonedGuarded(
    () {
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
    },
    (error, final stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await _initializeFirebase();

  // Initialize production services
  await _initializeProductionServices();

  runApp(const ProviderScope(child: AppointApp()));
}

Future<void> _initializeFirebase() async {
  // TODO: Use environment variables to determine which config to use
  const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
  
  if (environment == 'prod') {
    await Firebase.initializeApp(
      options: prod.DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: dev.DefaultFirebaseOptions.currentPlatform,
    );
  }
}

Future<void> _initializeProductionServices() async {
  try {
    // Initialize API client
    ApiClient.instance.initialize();

    // Initialize analytics
    await AnalyticsService.instance.initialize();

    // Initialize push notifications
    await PushNotificationService.instance.initialize();

    // Track app launch
    AnalyticsService.instance.trackAppLifecycle(
      event: 'app_launched',
      parameters: {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'version': '1.0.0',
      },
    );

    print('✅ Production services initialized successfully');
  } catch (e) {
    print('❌ Failed to initialize production services: $e');
    ErrorHandler.instance.logError(e, feature: 'app_initialization');
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  late Stream<ConnectivityResult> _connectivityStream;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _connectivityStream = Connectivity().onConnectivityChanged;
    _connectivityStream.listen((result) {
      final offline = result == ConnectivityResult.none;
      if (offline != _isOffline) {
        setState(() {
          _isOffline = offline;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    lightTheme = ref.watch(lightThemeProvider);
    darkTheme = ref.watch(darkThemeProvider);
    themeMode = ref.watch(themeModeProvider);

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
      builder: (context, child) => Stack(
          children: [
            child ?? const SizedBox.shrink(),
            if (_isOffline)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Material(
                  color: Colors.red,
                  elevation: 4,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      alignment: Alignment.center,
                      child: const Text(
                        'You are offline',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
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

class AppointApp extends ConsumerWidget {
  const AppointApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'APP-OINT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routerConfig: router,
      builder: (context, child) {
        // Add error handling wrapper
        return ErrorHandlerWrapper(child: child!);
      },
    );
  }
}

class ErrorHandlerWrapper extends StatelessWidget {
  const ErrorHandlerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: child,
      builder: (context, widget) {
        // Add global error handling
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          // Log error to analytics
          AnalyticsService.instance.trackError(
            error: errorDetails.exception.toString(),
            feature: 'app_error',
            context: {
              'library': errorDetails.library,
              'stack': errorDetails.stack.toString(),
            },
          );

          // Show user-friendly error screen
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please restart the app',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        // Restart app
                        // TODO: Implement app restart
                      },
                      child: const Text('Restart App'),
                    ),
                  ],
                ),
              ),
            ),
          );
        };

        return widget!;
      },
    );
  }
}
