class CrashlyticsService {
  Future<void> log(String message) async {
    // Replace with FirebaseCrashlytics.instance.log(message);
  }

  Future<void> recordError(dynamic error, StackTrace? stack) async {
    // Replace with FirebaseCrashlytics.instance.recordError(...);
  }
}
