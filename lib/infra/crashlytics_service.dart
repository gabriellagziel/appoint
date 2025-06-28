import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }

  Future<void> recordError(dynamic error, StackTrace? stack) async {
    await FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
  }
}
