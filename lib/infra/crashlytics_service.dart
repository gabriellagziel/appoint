import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class CrashlyticsService {
  Future<void> log(final String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }

  Future<void> recordError(final dynamic error, final StackTrace? stack) async {
    await FirebaseCrashlytics.instance.recordError(error, stack, fatal: false);
  }
}
