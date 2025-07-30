import 'dart:async';
import 'dart:math';

/// Real-Time Quality Monitor
///
/// Monitors quality metrics in real-time and provides live insights.
class QualityMonitor {
  static const Duration _updateInterval = Duration(seconds: 30);

  Timer? _monitoringTimer;
  final List<QualityMetric> _metrics = [];
  final List<QualityAlert> _alerts = [];
  final List<Function(QualityMetric)> _metricListeners = [];
  final List<Function(QualityAlert)> _alertListeners = [];

  /// Starts real-time quality monitoring
  void startMonitoring() {
    _monitoringTimer = Timer.periodic(_updateInterval, (timer) async {
      final metrics = await _collectQualityMetrics();

      for (final metric in metrics) {
        _metrics.add(metric);
        _notifyMetricListeners(metric);

        // Check for alerts
        final alert = _checkForAlert(metric);
        if (alert != null) {
          _alerts.add(alert);
          _notifyAlertListeners(alert);
        }
      }

      // Keep only last 1000 metrics
      if (_metrics.length > 1000) {
        _metrics.removeRange(0, _metrics.length - 1000);
      }

      // Keep only last 100 alerts
      if (_alerts.length > 100) {
        _alerts.removeRange(0, _alerts.length - 100);
      }
    });
  }

  /// Stops real-time quality monitoring
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
  }

  /// Adds a listener for quality metrics
  void addMetricListener(Function(QualityMetric) listener) {
    _metricListeners.add(listener);
  }

  /// Adds a listener for quality alerts
  void addAlertListener(Function(QualityAlert) listener) {
    _alertListeners.add(listener);
  }

  /// Collects current quality metrics
  Future<List<QualityMetric>> _collectQualityMetrics() async {
    final metrics = <QualityMetric>[];
    final now = DateTime.now();

    // Test coverage metric
    metrics.add(QualityMetric(
      name: 'test_coverage',
      value: _getTestCoverage(),
      timestamp: now,
      type: MetricType.coverage,
    ));

    // Test pass rate metric
    metrics.add(QualityMetric(
      name: 'test_pass_rate',
      value: _getTestPassRate(),
      timestamp: now,
      type: MetricType.passRate,
    ));

    // Build success rate metric
    metrics.add(QualityMetric(
      name: 'build_success_rate',
      value: _getBuildSuccessRate(),
      timestamp: now,
      type: MetricType.buildSuccess,
    ));

    // Code quality metric
    metrics.add(QualityMetric(
      name: 'code_quality_score',
      value: _getCodeQualityScore(),
      timestamp: now,
      type: MetricType.codeQuality,
    ));

    // Performance metric
    metrics.add(QualityMetric(
      name: 'performance_score',
      value: _getPerformanceScore(),
      timestamp: now,
      type: MetricType.performance,
    ));

    return metrics;
  }

  /// Gets current test coverage
  double _getTestCoverage() {
    // Simulate test coverage calculation
    return 0.75 + (Random().nextDouble() * 0.2); // 75-95%
  }

  /// Gets current test pass rate
  double _getTestPassRate() {
    // Simulate test pass rate calculation
    return 0.85 + (Random().nextDouble() * 0.1); // 85-95%
  }

  /// Gets current build success rate
  double _getBuildSuccessRate() {
    // Simulate build success rate calculation
    return 0.90 + (Random().nextDouble() * 0.08); // 90-98%
  }

  /// Gets current code quality score
  double _getCodeQualityScore() {
    // Simulate code quality score calculation
    return 0.80 + (Random().nextDouble() * 0.15); // 80-95%
  }

  /// Gets current performance score
  double _getPerformanceScore() {
    // Simulate performance score calculation
    return 0.85 + (Random().nextDouble() * 0.12); // 85-97%
  }

  /// Checks if a metric should trigger an alert
  QualityAlert? _checkForAlert(QualityMetric metric) {
    switch (metric.type) {
      case MetricType.coverage:
        if (metric.value < 0.70) {
          return QualityAlert(
            type: AlertType.lowCoverage,
            severity: AlertSeverity.warning,
            message:
                'Test coverage is below 70%: ${(metric.value * 100).toStringAsFixed(1)}%',
            metric: metric,
            timestamp: DateTime.now(),
          );
        }
        break;

      case MetricType.passRate:
        if (metric.value < 0.80) {
          return QualityAlert(
            type: AlertType.lowPassRate,
            severity: AlertSeverity.error,
            message:
                'Test pass rate is below 80%: ${(metric.value * 100).toStringAsFixed(1)}%',
            metric: metric,
            timestamp: DateTime.now(),
          );
        }
        break;

      case MetricType.buildSuccess:
        if (metric.value < 0.85) {
          return QualityAlert(
            type: AlertType.buildFailure,
            severity: AlertSeverity.critical,
            message:
                'Build success rate is below 85%: ${(metric.value * 100).toStringAsFixed(1)}%',
            metric: metric,
            timestamp: DateTime.now(),
          );
        }
        break;

      case MetricType.codeQuality:
        if (metric.value < 0.75) {
          return QualityAlert(
            type: AlertType.lowCodeQuality,
            severity: AlertSeverity.warning,
            message:
                'Code quality score is below 75%: ${(metric.value * 100).toStringAsFixed(1)}%',
            metric: metric,
            timestamp: DateTime.now(),
          );
        }
        break;

      case MetricType.performance:
        if (metric.value < 0.80) {
          return QualityAlert(
            type: AlertType.performanceIssue,
            severity: AlertSeverity.error,
            message:
                'Performance score is below 80%: ${(metric.value * 100).toStringAsFixed(1)}%',
            metric: metric,
            timestamp: DateTime.now(),
          );
        }
        break;
    }

    return null;
  }

  /// Notifies metric listeners
  void _notifyMetricListeners(QualityMetric metric) {
    for (final listener in _metricListeners) {
      try {
        listener(metric);
      } catch (e) {
        print('Error in metric listener: $e');
      }
    }
  }

  /// Notifies alert listeners
  void _notifyAlertListeners(QualityAlert alert) {
    for (final listener in _alertListeners) {
      try {
        listener(alert);
      } catch (e) {
        print('Error in alert listener: $e');
      }
    }
  }

  /// Gets quality summary for the specified time window
  QualitySummary getQualitySummary({Duration? timeWindow}) {
    final window = timeWindow ?? const Duration(hours: 1);
    final cutoff = DateTime.now().subtract(window);

    final recentMetrics =
        _metrics.where((m) => m.timestamp.isAfter(cutoff)).toList();

    if (recentMetrics.isEmpty) {
      return QualitySummary.empty();
    }

    final coverageValues = recentMetrics
        .where((m) => m.type == MetricType.coverage)
        .map((m) => m.value)
        .toList();
    final coverage = coverageValues.isEmpty
        ? 0.0
        : coverageValues.reduce((a, b) => a + b) / coverageValues.length;

    final passRateValues = recentMetrics
        .where((m) => m.type == MetricType.passRate)
        .map((m) => m.value)
        .toList();
    final passRate = passRateValues.isEmpty
        ? 0.0
        : passRateValues.reduce((a, b) => a + b) / passRateValues.length;

    final buildSuccessValues = recentMetrics
        .where((m) => m.type == MetricType.buildSuccess)
        .map((m) => m.value)
        .toList();
    final buildSuccess = buildSuccessValues.isEmpty
        ? 0.0
        : buildSuccessValues.reduce((a, b) => a + b) /
            buildSuccessValues.length;

    final codeQualityValues = recentMetrics
        .where((m) => m.type == MetricType.codeQuality)
        .map((m) => m.value)
        .toList();
    final codeQuality = codeQualityValues.isEmpty
        ? 0.0
        : codeQualityValues.reduce((a, b) => a + b) / codeQualityValues.length;

    final performanceValues = recentMetrics
        .where((m) => m.type == MetricType.performance)
        .map((m) => m.value)
        .toList();
    final performance = performanceValues.isEmpty
        ? 0.0
        : performanceValues.reduce((a, b) => a + b) / performanceValues.length;

    final overallScore =
        (coverage + passRate + buildSuccess + codeQuality + performance) / 5;

    return QualitySummary(
      overallScore: overallScore,
      coverage: coverage,
      passRate: passRate,
      buildSuccess: buildSuccess,
      codeQuality: codeQuality,
      performance: performance,
      activeAlerts:
          _alerts.where((a) => a.severity == AlertSeverity.critical).length,
      lastUpdated: DateTime.now(),
    );
  }

  /// Gets quality trends
  List<QualityTrend> getQualityTrends({Duration? timeWindow}) {
    final window = timeWindow ?? const Duration(hours: 1);
    final cutoff = DateTime.now().subtract(window);

    final recentMetrics =
        _metrics.where((m) => m.timestamp.isAfter(cutoff)).toList();
    final trends = <QualityTrend>[];

    // Group by metric type
    final metricTypes = MetricType.values;
    for (final type in metricTypes) {
      final typeMetrics = recentMetrics.where((m) => m.type == type).toList();
      if (typeMetrics.length >= 2) {
        final values = typeMetrics.map((m) => m.value).toList();
        final trend = _calculateTrend(values, type);
        trends.add(trend);
      }
    }

    return trends;
  }

  /// Calculates trend for a series of values
  QualityTrend _calculateTrend(List<double> values, MetricType type) {
    if (values.length < 2) {
      return QualityTrend(
        type: type,
        direction: TrendDirection.stable,
        slope: 0.0,
        confidence: 0.0,
      );
    }

    // Simple linear regression
    final n = values.length;
    final indices = List.generate(n, (i) => i.toDouble());

    final sumX = indices.reduce((a, b) => a + b);
    final sumY = values.reduce((a, b) => a + b);
    double sumXY = 0;
    final sumX2 = indices.map((x) => x * x).reduce((a, b) => a + b);

    for (int i = 0; i < n; i++) {
      sumXY += indices[i] * values[i];
    }

    final slope = (n * sumXY - sumX * sumY) / (n * sumX2 - sumX * sumX);

    TrendDirection direction;
    if (slope > 0.01) {
      direction = TrendDirection.improving;
    } else if (slope < -0.01) {
      direction = TrendDirection.declining;
    } else {
      direction = TrendDirection.stable;
    }

    final confidence = (1.0 - (values.length / 100.0)).clamp(0.0, 1.0);

    return QualityTrend(
      type: type,
      direction: direction,
      slope: slope,
      confidence: confidence,
    );
  }
}

class QualityMetric {
  final String name;
  final double value;
  final DateTime timestamp;
  final MetricType type;

  QualityMetric({
    required this.name,
    required this.value,
    required this.timestamp,
    required this.type,
  });
}

class QualityAlert {
  final AlertType type;
  final AlertSeverity severity;
  final String message;
  final QualityMetric metric;
  final DateTime timestamp;

  QualityAlert({
    required this.type,
    required this.severity,
    required this.message,
    required this.metric,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'QualityAlert(type: $type, severity: $severity, message: $message)';
  }
}

class QualitySummary {
  final double overallScore;
  final double coverage;
  final double passRate;
  final double buildSuccess;
  final double codeQuality;
  final double performance;
  final int activeAlerts;
  final DateTime lastUpdated;

  QualitySummary({
    required this.overallScore,
    required this.coverage,
    required this.passRate,
    required this.buildSuccess,
    required this.codeQuality,
    required this.performance,
    required this.activeAlerts,
    required this.lastUpdated,
  });

  factory QualitySummary.empty() {
    return QualitySummary(
      overallScore: 0.0,
      coverage: 0.0,
      passRate: 0.0,
      buildSuccess: 0.0,
      codeQuality: 0.0,
      performance: 0.0,
      activeAlerts: 0,
      lastUpdated: DateTime.now(),
    );
  }

  @override
  String toString() {
    return 'QualitySummary(overall: ${(overallScore * 100).toStringAsFixed(1)}%, alerts: $activeAlerts)';
  }
}

class QualityTrend {
  final MetricType type;
  final TrendDirection direction;
  final double slope;
  final double confidence;

  QualityTrend({
    required this.type,
    required this.direction,
    required this.slope,
    required this.confidence,
  });

  @override
  String toString() {
    return 'QualityTrend(type: $type, direction: $direction, confidence: ${confidence.toStringAsFixed(2)})';
  }
}

enum MetricType {
  coverage,
  passRate,
  buildSuccess,
  codeQuality,
  performance,
}

enum AlertType {
  lowCoverage,
  lowPassRate,
  buildFailure,
  lowCodeQuality,
  performanceIssue,
}

enum AlertSeverity {
  info,
  warning,
  error,
  critical,
}

enum TrendDirection {
  improving,
  declining,
  stable,
}
