import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class HealthMetrics {
  final String status;
  final DateTime timestamp;
  final String service;
  final String version;
  final String environment;
  final Map<String, dynamic> checks;
  final Map<String, dynamic> metrics;

  HealthMetrics({
    required this.status,
    required this.timestamp,
    required this.service,
    required this.version,
    required this.environment,
    required this.checks,
    required this.metrics,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      'service': service,
      'version': version,
      'environment': environment,
      'checks': checks,
      'metrics': metrics,
    };
  }
}

class HealthService {
  static const String version = '1.0.0';
  static const String serviceName = 'app-oint-flutter';
  
  // Track app metrics
  static int _requestCount = 0;
  static final List<Duration> _responseTimeHistory = [];
  static final List<String> _errorHistory = [];
  static DateTime? _lastErrorTime;
  static final DateTime _startTime = DateTime.now();

  // Increment request counter
  static void recordRequest() {
    _requestCount++;
  }

  // Record response time
  static void recordResponseTime(Duration duration) {
    _responseTimeHistory.add(duration);
    // Keep only last 1000 entries
    if (_responseTimeHistory.length > 1000) {
      _responseTimeHistory.removeAt(0);
    }
  }

  // Record error
  static void recordError(String error) {
    _errorHistory.add(error);
    _lastErrorTime = DateTime.now();
    // Keep only last 100 errors
    if (_errorHistory.length > 100) {
      _errorHistory.removeAt(0);
    }
  }

  // Get basic liveness status
  static Map<String, dynamic> getLivenessStatus() {
    return {
      'status': 'alive',
      'timestamp': DateTime.now().toIso8601String(),
      'service': serviceName,
      'uptime': DateTime.now().difference(_startTime).inSeconds,
    };
  }

  // Get readiness status with dependency checks
  static Future<Map<String, dynamic>> getReadinessStatus() async {
    final checks = <String, dynamic>{};
    String overallStatus = 'ready';

    // Check if app is initialized
    checks['app_initialization'] = {
      'status': 'pass',
      'message': 'App successfully initialized'
    };

    // Check if we're running on web
    if (kIsWeb) {
      checks['platform'] = {
        'status': 'pass',
        'message': 'Running on web platform'
      };
    } else {
      checks['platform'] = {
        'status': 'pass',
        'message': 'Running on mobile platform'
      };
    }

    // Check recent errors
    final recentErrors = _errorHistory.where((error) {
      return _lastErrorTime != null && 
             DateTime.now().difference(_lastErrorTime!).inMinutes < 5;
    }).toList();

    if (recentErrors.length > 10) {
      checks['error_rate'] = {
        'status': 'fail',
        'message': 'High error rate detected: ${recentErrors.length} errors in last 5 minutes'
      };
      overallStatus = 'not_ready';
    } else {
      checks['error_rate'] = {
        'status': 'pass',
        'message': 'Error rate within acceptable limits'
      };
    }

    return {
      'status': overallStatus,
      'timestamp': DateTime.now().toIso8601String(),
      'service': serviceName,
      'checks': checks,
    };
  }

  // Get comprehensive health status with metrics
  static Future<HealthMetrics> getHealthStatus() async {
    final checks = <String, dynamic>{};
    String overallStatus = 'healthy';

    // App initialization check
    checks['app_initialization'] = {
      'status': 'pass',
      'responseTime': 0,
    };

    // Platform check
    checks['platform'] = {
      'status': 'pass',
      'responseTime': 0,
      'details': kIsWeb ? 'web' : Platform.operatingSystem,
    };

    // Error rate check
    final recentErrors = _errorHistory.where((error) {
      return _lastErrorTime != null && 
             DateTime.now().difference(_lastErrorTime!).inMinutes < 5;
    }).toList();

    if (recentErrors.length > 10) {
      checks['error_rate'] = {
        'status': 'fail',
        'responseTime': 0,
        'error': 'High error rate: ${recentErrors.length} errors in 5 minutes',
      };
      overallStatus = 'degraded';
    } else {
      checks['error_rate'] = {
        'status': 'pass',
        'responseTime': 0,
      };
    }

    // Calculate metrics
    final metrics = _calculateMetrics();

    return HealthMetrics(
      status: overallStatus,
      timestamp: DateTime.now(),
      service: serviceName,
      version: version,
      environment: kDebugMode ? 'development' : 'production',
      checks: checks,
      metrics: metrics,
    );
  }

  // Calculate performance metrics
  static Map<String, dynamic> _calculateMetrics() {
    final uptime = DateTime.now().difference(_startTime);
    
    // Calculate response time percentiles
    double p50 = 0, p95 = 0, p99 = 0;
    if (_responseTimeHistory.isNotEmpty) {
      final sorted = List<Duration>.from(_responseTimeHistory)
        ..sort((a, b) => a.compareTo(b));
      
      final len = sorted.length;
      p50 = sorted[(len * 0.5).floor()].inMilliseconds.toDouble();
      p95 = sorted[(len * 0.95).floor()].inMilliseconds.toDouble();
      p99 = sorted[(len * 0.99).floor()].inMilliseconds.toDouble();
    }

    // Calculate error rates
    final recentErrors5min = _errorHistory.where((error) {
      return _lastErrorTime != null && 
             DateTime.now().difference(_lastErrorTime!).inMinutes < 5;
    }).length;

    final recentErrors1hour = _errorHistory.where((error) {
      return _lastErrorTime != null && 
             DateTime.now().difference(_lastErrorTime!).inHours < 1;
    }).length;

    return {
      'uptime_seconds': uptime.inSeconds,
      'request_count': _requestCount,
      'response_time_p50_ms': p50,
      'response_time_p95_ms': p95,
      'response_time_p99_ms': p99,
      'errors_5min': recentErrors5min,
      'errors_1hour': recentErrors1hour,
      'total_errors': _errorHistory.length,
      'memory_usage': _getMemoryUsage(),
    };
  }

  // Get memory usage (simplified for Flutter)
  static Map<String, dynamic> _getMemoryUsage() {
    if (kIsWeb) {
      return {
        'platform': 'web',
        'note': 'Memory metrics not available in web environment'
      };
    } else {
      // For mobile platforms, this would require platform-specific implementation
      return {
        'platform': Platform.operatingSystem,
        'note': 'Memory metrics require platform-specific implementation'
      };
    }
  }

  // Export metrics in Prometheus format (for web)
  static String getPrometheusMetrics() {
    final metrics = _calculateMetrics();
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    return '''
# HELP flutter_app_uptime_seconds App uptime in seconds
# TYPE flutter_app_uptime_seconds gauge
flutter_app_uptime_seconds ${metrics['uptime_seconds']} $timestamp

# HELP flutter_app_requests_total Total number of requests processed
# TYPE flutter_app_requests_total counter
flutter_app_requests_total ${metrics['request_count']} $timestamp

# HELP flutter_app_response_time_ms Response time percentiles in milliseconds
# TYPE flutter_app_response_time_ms histogram
flutter_app_response_time_ms{quantile="0.5"} ${metrics['response_time_p50_ms']} $timestamp
flutter_app_response_time_ms{quantile="0.95"} ${metrics['response_time_p95_ms']} $timestamp
flutter_app_response_time_ms{quantile="0.99"} ${metrics['response_time_p99_ms']} $timestamp

# HELP flutter_app_errors_total Total number of errors
# TYPE flutter_app_errors_total counter
flutter_app_errors_5min ${metrics['errors_5min']} $timestamp
flutter_app_errors_1hour ${metrics['errors_1hour']} $timestamp
flutter_app_errors_total ${metrics['total_errors']} $timestamp
    '''.trim();
  }
}

// Global error handler integration
class HealthAwareErrorHandler {
  static void handleError(Object error, StackTrace? stackTrace) {
    HealthService.recordError(error.toString());
    
    // You can also integrate with your existing error reporting
    if (kDebugMode) {
      print('Error: $error');
      print('Stack trace: $stackTrace');
    }
  }
}

// Extension for easy response time tracking
extension HealthTracking on Future<T> {
  Future<T> trackResponseTime<T>() async {
    final stopwatch = Stopwatch()..start();
    try {
      final result = await this;
      HealthService.recordResponseTime(stopwatch.elapsed);
      return result;
    } catch (error) {
      HealthService.recordError(error.toString());
      HealthService.recordResponseTime(stopwatch.elapsed);
      rethrow;
    } finally {
      stopwatch.stop();
    }
  }
}