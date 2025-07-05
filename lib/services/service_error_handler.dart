mixin ServiceErrorHandler {
  Future<T?> handleServiceCall<T>(final Future<T> Function() fn,
      {final void Function(Object, StackTrace)? onError}) async {
    try {
      return await fn();
    } catch (e, stack) {
      onError?.call(e, stack);
      // Optionally log to Crashlytics or another service here
      return null;
    }
  }
}
