mixin ServiceErrorHandler {
  Future<T?> handleServiceCall<T>(
    Future<T> Function() fn, {
    void Function(Object, StackTrace)? onError,
  }) async {
    try {
      return await fn();
    } catch (e, stackTrace) {
      onError?.call(e, stackTrace);
      // Optionally log to Crashlytics or another service here
      return null;
    }
  }
}
