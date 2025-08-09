import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'app_router.dart';
import 'package:appoint/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // App Check for web
  try {
    await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider('RECAPTCHA_V3_SITE_KEY'),
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug,
    );
  } catch (_) {}

  runApp(const ProviderScope(child: AppOintApp()));
}

class AppOintApp extends StatelessWidget {
  const AppOintApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'App-Oint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
