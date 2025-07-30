import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PerformanceMetrics {
  PerformanceMetrics({
    required this.name,
    required this.duration,
    required this.timestamp,
    this.attributes,
  });
  final String name;
  final Duration duration;
  final Map<String, dynamic>? attributes;
  final DateTime timestamp;

  @override
  String toString() =>
      'PerformanceMetrics: $name took ${duration.inMilliseconds}ms';
}

/// Service for monitoring application performance
class PerformanceMonitoringService {
  factory PerformanceMonitoringService() => _instance;
  PerformanceMonitoringService._internal();
  static final PerformanceMonitoringService _instance =
      PerformanceMonitoringService._internal();

  final Map<String, Stopwatch> _activeTraces = {};
  final Map<String, List<Duration>> _traceHistory = {};
  final Map<String, int> _errorCounts = {};
  final Map<String, Duration> _operationTimes = {};

  /// Start a performance trace
  Future<void> startTrace(
    final String name, {
    Map<String, dynamic>? attributes,
  }) async {
    if (_activeTraces.containsKey(name)) {
      developer.log(
        'Trace $name already active',
        name: 'PerformanceMonitoring',
      );
      return;
    }

    final stopwatch = Stopwatch()..start();
    _activeTraces[name] = stopwatch;

    if (kDebugMode) {
      developer.log('Started trace: $name', name: 'PerformanceMonitoring');
    }

    // Send to Firebase Performance if available
    try {
      // Firebase Performance integration would go here
      // await FirebasePerformance.instance.newTrace(name).start();
    } catch (e) {
      developer.log(
        'Failed to start Firebase trace: $e',
        name: 'PerformanceMonitoring',
      );
    }
  }

  /// Stop a performance trace
  Future<void> stopTrace(String name) async {
    final stopwatch = _activeTraces.remove(name);
    if (stopwatch == null) {
      developer.log('Trace $name not found', name: 'PerformanceMonitoring');
      return;
    }

    stopwatch.stop();
    final duration = stopwatch.elapsed;

    // Store trace history
    _traceHistory.putIfAbsent(name, () => []).add(duration);

    if (kDebugMode) {
      developer.log(
        'Stopped trace: $name (${duration.inMilliseconds}ms)',
        name: 'PerformanceMonitoring',
      );
    }

    // Send to Firebase Performance if available
    try {
      // Firebase Performance integration would go here
      // trace = FirebasePerformance.instance.newTrace(name);
      // trace.setMetric('duration', duration.inMilliseconds);
      // await trace.stop();
    } catch (e) {
      developer.log(
        'Failed to stop Firebase trace: $e',
        name: 'PerformanceMonitoring',
      );
    }
  }

  /// Measure execution time of a synchronous function
  T measureExecutionSync<T>(
    String name,
    final T Function() function, {
    Map<String, dynamic>? attributes,
  }) {
    final stopwatch = Stopwatch()..start();

    try {
      final result = function();
      stopwatch.stop();

      _recordOperation(name, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      _recordError(name, e);
      rethrow;
    }
  }

  /// Measure execution time of an asynchronous function
  Future<T> measureExecutionAsync<T>(
    String name,
    final Future<T> Function() function, {
    Map<String, dynamic>? attributes,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await function();
      stopwatch.stop();

      _recordOperation(name, stopwatch.elapsed);
      return result;
    } catch (e) {
      stopwatch.stop();
      _recordError(name, e);
      rethrow;
    }
  }

  /// Record an operation time
  void _recordOperation(String name, final Duration duration) {
    _operationTimes[name] = duration;

    if (kDebugMode) {
      developer.log(
        'Operation $name completed in ${duration.inMilliseconds}ms',
        name: 'PerformanceMonitoring',
      );
    }
  }

  /// Record an error
  void _recordError(String name, final Object error) {
    _errorCounts[name] = (_errorCounts[name] ?? 0) + 1;

    developer.log(
      'Error in operation $name: $error',
      name: 'PerformanceMonitoring',
    );
  }

  /// Get performance metrics
  Map<String, dynamic> getMetrics() {
    final metrics = <String, dynamic>{};

    // Operation times
    metrics['operation_times'] = _operationTimes
        .map((key, final value) => MapEntry(key, value.inMilliseconds));

    // Error counts
    metrics['error_counts'] = _errorCounts;

    // Trace history
    metrics['trace_history'] = _traceHistory.map(
      (key, final value) =>
          MapEntry(key, value.map((d) => d.inMilliseconds).toList()),
    );

    // Active traces
    metrics['active_traces'] = _activeTraces.length;

    return metrics;
  }

  /// Get average operation time
  Duration? getAverageOperationTime(String name) {
    final times = _traceHistory[name];
    if (times == null || times.isEmpty) return null;

    final total = times.fold<Duration>(
      Duration.zero,
      (sum, final time) => sum + time,
    );

    return Duration(milliseconds: total.inMilliseconds ~/ times.length);
  }

  /// Get error rate for an operation
  double getErrorRate(String name) {
    final errorCount = _errorCounts[name] ?? 0;
    final totalOperations = (_traceHistory[name]?.length ?? 0) + errorCount;

    if (totalOperations == 0) return 0;
    return errorCount / totalOperations;
  }

  /// Clear all metrics
  void clearMetrics() {
    _activeTraces.clear();
    _traceHistory.clear();
    _errorCounts.clear();
    _operationTimes.clear();
  }

  /// Export metrics for analysis
  Map<String, dynamic> exportMetrics() => {
        'timestamp': DateTime.now().toIso8601String(),
        'metrics': getMetrics(),
        'summary': {
          'total_operations': _operationTimes.length,
          'total_errors':
              _errorCounts.values.fold(0, (sum, final count) => sum + count),
          'active_traces': _activeTraces.length,
        },
      };
}

/// Riverpod provider for performance monitoring service
final REDACTED_TOKEN =
    Provider<PerformanceMonitoringService>(
        (ref) => PerformanceMonitoringService());

/// Extension for easy performance monitoring
extension PerformanceMonitoringExtension on WidgetRef {
  /// Measure execution time of a synchronous function
  T measureExecutionSync<T>(
    String name,
    final T Function() function, {
    Map<String, dynamic>? attributes,
  }) {
    final service = read(REDACTED_TOKEN);
    return service.measureExecutionSync(name, function, attributes: attributes);
  }

  /// Measure execution time of an asynchronous function
  Future<T> measureExecutionAsync<T>(
    String name,
    final Future<T> Function() function, {
    Map<String, dynamic>? attributes,
  }) async {
    final service = read(REDACTED_TOKEN);
    return service.measureExecutionAsync(
      name,
      function,
      attributes: attributes,
    );
  }

  /// Start a performance trace
  Future<void> startTrace(
    final String name, {
    Map<String, dynamic>? attributes,
  }) async {
    final service = read(REDACTED_TOKEN);
    await service.startTrace(name, attributes: attributes);
  }

  /// Stop a performance trace
  Future<void> stopTrace(String name) async {
    final service = read(REDACTED_TOKEN);
    await service.stopTrace(name);
  }
}
