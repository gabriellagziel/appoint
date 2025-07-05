import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final FirebasePerformance _performance = FirebasePerformance.instance;

  /// Track custom trace
  Future<void> trackTrace(
    final String name,
    final Future<void> Function() operation,
  ) async {
    final trace = _performance.newTrace(name);
    await trace.start();

    try {
      await operation();
    } finally {
      await trace.stop();
    }
  }

  /// Track HTTP request
  Future<void> trackHttpRequest(
    final String url,
    final String method,
    final int responseCode,
  ) async {
    final metric = _performance.newHttpMetric(
      url,
      HttpMethod.values.firstWhere(
        (final e) =>
            e.toString().split('.').last.toUpperCase() == method.toUpperCase(),
      ),
    );

    await metric.start();
    metric.httpResponseCode = responseCode;
    await metric.stop();
  }

  /// Track screen load time
  Future<void> trackScreenLoad(
    final String screenName,
    final Future<void> Function() loadOperation,
  ) async {
    final trace = _performance.newTrace('screen_load_$screenName');
    await trace.start();

    try {
      await loadOperation();
    } finally {
      await trace.stop();
    }
  }

  /// Track memory usage
  void trackMemoryUsage() {
    if (kDebugMode) {
      // In debug mode, we can track memory usage
      // This would be implemented with platform-specific code
    }
  }

  /// Track app startup time
  Future<void> trackAppStartup(
      final Future<void> Function() startupOperation) async {
    final trace = _performance.newTrace('app_startup');
    await trace.start();

    try {
      await startupOperation();
    } finally {
      await trace.stop();
    }
  }

  /// Track feature usage
  void trackFeatureUsage(final String featureName) {
    final trace = _performance.newTrace('feature_usage_$featureName');
    trace.start();
    trace.stop();
  }

  /// Track error performance
  void trackError(final String errorType, final String errorMessage) {
    final trace = _performance.newTrace('error_$errorType');
    trace.putAttribute('error_message', errorMessage);
    trace.start();
    trace.stop();
  }
}

// Riverpod providers
final performanceServiceProvider = Provider<PerformanceService>((final ref) {
  return PerformanceService();
});

final performanceEnabledProvider = StateProvider<bool>((final ref) {
  return !kDebugMode; // Enable in release mode only
});
