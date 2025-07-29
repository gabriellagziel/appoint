import 'dart:io';
import 'package:yaml/yaml.dart';

/// Performance budget validator
///
/// Validates performance metrics against defined budgets and generates reports
class PerformanceBudgetValidator {
  static const String _budgetFile =
      'performance/budgets/performance_budget.yaml';

  late Map<String, dynamic> _budget;

  /// Loads the performance budget configuration
  Future<void> loadBudget() async {
    try {
      final file = File(_budgetFile);
      if (!await file.exists()) {
        throw Exception('Performance budget file not found: $_budgetFile');
      }

      final content = await file.readAsString();
      _budget = loadYaml(content) as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to load performance budget: $e');
    }
  }

  /// Validates a single metric against its budget
  BudgetValidationResult validateMetric({
    required String metricPath,
    required dynamic value,
    String? platform,
    String? deviceType,
  }) {
    try {
      final budget = _getBudgetForMetric(metricPath, platform, deviceType);
      if (budget == null) {
        return BudgetValidationResult(
          metric: metricPath,
          value: value,
          isValid: false,
          severity: BudgetViolationSeverity.error,
          message: 'No budget defined for metric: $metricPath',
        );
      }

      final target = budget['target'];
      final warning = budget['warning'];
      final critical = budget['critical'];

      if (value <= target) {
        return BudgetValidationResult(
          metric: metricPath,
          value: value,
          target: target,
          isValid: true,
          severity: BudgetViolationSeverity.none,
          message: 'Metric within target budget',
        );
      } else if (value <= warning) {
        return BudgetValidationResult(
          metric: metricPath,
          value: value,
          target: target,
          warning: warning,
          isValid: true,
          severity: BudgetViolationSeverity.warning,
          message: 'Metric exceeds target but within warning threshold',
        );
      } else if (value <= critical) {
        return BudgetValidationResult(
          metric: metricPath,
          value: value,
          target: target,
          warning: warning,
          critical: critical,
          isValid: false,
          severity: BudgetViolationSeverity.critical,
          message:
              'Metric exceeds warning threshold but within critical threshold',
        );
      } else {
        return BudgetValidationResult(
          metric: metricPath,
          value: value,
          target: target,
          warning: warning,
          critical: critical,
          isValid: false,
          severity: BudgetViolationSeverity.error,
          message: 'Metric exceeds critical threshold',
        );
      }
    } catch (e) {
      return BudgetValidationResult(
        metric: metricPath,
        value: value,
        isValid: false,
        severity: BudgetViolationSeverity.error,
        message: 'Error validating metric: $e',
      );
    }
  }

  /// Validates multiple metrics against their budgets
  BudgetValidationReport validateMetrics({
    required Map<String, dynamic> metrics,
    String? platform,
    String? deviceType,
  }) {
    final results = <BudgetValidationResult>[];

    for (final entry in metrics.entries) {
      final result = validateMetric(
        metricPath: entry.key,
        value: entry.value,
        platform: platform,
        deviceType: deviceType,
      );
      results.add(result);
    }

    return BudgetValidationReport(
      results: results,
      platform: platform,
      deviceType: deviceType,
      timestamp: DateTime.now(),
    );
  }

  /// Validates startup time performance
  BudgetValidationResult validateStartupTime({
    required Duration startupTime,
    String? platform,
    String? deviceType,
  }) {
    return validateMetric(
      metricPath: 'app_performance.startup_time',
      value: startupTime.inMilliseconds,
      platform: platform,
      deviceType: deviceType,
    );
  }

  /// Validates frame time performance
  BudgetValidationResult validateFrameTime({
    required Duration frameTime,
    String? platform,
    String? deviceType,
  }) {
    return validateMetric(
      metricPath: 'app_performance.frame_time',
      value: frameTime.inMilliseconds,
      platform: platform,
      deviceType: deviceType,
    );
  }

  /// Validates jank percentage
  BudgetValidationResult validateJankPercentage({
    required double jankPercentage,
    String? platform,
    String? deviceType,
  }) {
    return validateMetric(
      metricPath: 'app_performance.jank_percentage',
      value: jankPercentage,
      platform: platform,
      deviceType: deviceType,
    );
  }

  /// Validates memory usage
  BudgetValidationResult validateMemoryUsage({
    required int memoryUsageMB,
    String? platform,
    String? deviceType,
  }) {
    return validateMetric(
      metricPath: 'memory_usage.baseline',
      value: memoryUsageMB,
      platform: platform,
      deviceType: deviceType,
    );
  }

  /// Validates network response time
  BudgetValidationResult validateNetworkResponseTime({
    required Duration responseTime,
    String? platform,
    String? deviceType,
  }) {
    return validateMetric(
      metricPath: 'network_performance.response_time',
      value: responseTime.inMilliseconds,
      platform: platform,
      deviceType: deviceType,
    );
  }

  /// Gets the budget configuration for a specific metric
  Map<String, dynamic>? _getBudgetForMetric(
    String metricPath,
    String? platform,
    String? deviceType,
  ) {
    final pathParts = metricPath.split('.');
    Map<String, dynamic>? current = _budget;

    // Navigate to the metric in the budget
    for (final part in pathParts) {
      if (current == null || !current.containsKey(part)) {
        return null;
      }
      current = current[part] as Map<String, dynamic>?;
    }

    if (current == null) return null;

    // Apply platform-specific overrides
    if (platform != null && _budget.containsKey('platforms')) {
      final platforms = _budget['platforms'] as Map<String, dynamic>;
      if (platforms.containsKey(platform)) {
        final platformBudget = platforms[platform] as Map<String, dynamic>;
        final platformMetric = _getNestedValue(platformBudget, pathParts);
        if (platformMetric != null) {
          current = _mergeBudgets(current, platformMetric);
        }
      }
    }

    // Apply device-specific overrides
    if (deviceType != null && _budget.containsKey('devices')) {
      final devices = _budget['devices'] as Map<String, dynamic>;
      if (devices.containsKey(deviceType)) {
        final deviceBudget = devices[deviceType] as Map<String, dynamic>;
        final deviceMetric = _getNestedValue(deviceBudget, pathParts);
        if (deviceMetric != null) {
          current = _mergeBudgets(current, deviceMetric);
        }
      }
    }

    return current;
  }

  /// Gets a nested value from a map using path parts
  Map<String, dynamic>? _getNestedValue(
    Map<String, dynamic> map,
    List<String> pathParts,
  ) {
    Map<String, dynamic>? current = map;

    for (final part in pathParts) {
      if (current == null || !current.containsKey(part)) {
        return null;
      }
      current = current[part] as Map<String, dynamic>?;
    }

    return current;
  }

  /// Merges two budget configurations
  Map<String, dynamic> _mergeBudgets(
    Map<String, dynamic> base,
    Map<String, dynamic> override,
  ) {
    final merged = Map<String, dynamic>.from(base);
    merged.addAll(override);
    return merged;
  }

  /// Detects performance regressions
  List<PerformanceRegression> detectRegressions({
    required Map<String, dynamic> currentMetrics,
    required Map<String, dynamic> baselineMetrics,
  }) {
    final regressions = <PerformanceRegression>[];
    final regressionThresholds =
        _budget['regression_detection'] as Map<String, dynamic>;

    for (final entry in currentMetrics.entries) {
      final metric = entry.key;
      final currentValue = entry.value;
      final baselineValue = baselineMetrics[metric];

      if (baselineValue != null &&
          baselineValue is num &&
          currentValue is num) {
        final percentageIncrease =
            ((currentValue - baselineValue) / baselineValue) * 100;

        final threshold = _getRegressionThreshold(metric, regressionThresholds);
        final significantThreshold =
            REDACTED_TOKEN(metric, regressionThresholds);

        if (percentageIncrease >= significantThreshold) {
          regressions.add(PerformanceRegression(
            metric: metric,
            baselineValue: baselineValue,
            currentValue: currentValue,
            percentageIncrease: percentageIncrease,
            severity: PerformanceRegressionSeverity.significant,
            threshold: significantThreshold,
          ));
        } else if (percentageIncrease >= threshold) {
          regressions.add(PerformanceRegression(
            metric: metric,
            baselineValue: baselineValue,
            currentValue: currentValue,
            percentageIncrease: percentageIncrease,
            severity: PerformanceRegressionSeverity.minor,
            threshold: threshold,
          ));
        }
      }
    }

    return regressions;
  }

  /// Gets the regression threshold for a metric
  double _getRegressionThreshold(
      String metric, Map<String, dynamic> thresholds) {
    final metricThresholds = thresholds[metric] as Map<String, dynamic>?;
    return metricThresholds?['regression_threshold'] as double? ?? 10.0;
  }

  /// Gets the significant regression threshold for a metric
  double REDACTED_TOKEN(
      String metric, Map<String, dynamic> thresholds) {
    final metricThresholds = thresholds[metric] as Map<String, dynamic>?;
    return metricThresholds?['significant_regression'] as double? ?? 25.0;
  }

  /// Generates a performance budget report
  PerformanceBudgetReport generateReport({
    required BudgetValidationReport validationReport,
    List<PerformanceRegression>? regressions,
  }) {
    final totalMetrics = validationReport.results.length;
    final passedMetrics =
        validationReport.results.where((r) => r.isValid).length;
    final failedMetrics = totalMetrics - passedMetrics;

    final criticalViolations = validationReport.results
        .where((r) => r.severity == BudgetViolationSeverity.critical)
        .length;

    final errorViolations = validationReport.results
        .where((r) => r.severity == BudgetViolationSeverity.error)
        .length;

    final warningViolations = validationReport.results
        .where((r) => r.severity == BudgetViolationSeverity.warning)
        .length;

    return PerformanceBudgetReport(
      validationReport: validationReport,
      regressions: regressions ?? [],
      summary: BudgetSummary(
        totalMetrics: totalMetrics,
        passedMetrics: passedMetrics,
        failedMetrics: failedMetrics,
        criticalViolations: criticalViolations,
        errorViolations: errorViolations,
        warningViolations: warningViolations,
        passRate: totalMetrics > 0 ? (passedMetrics / totalMetrics) * 100 : 0.0,
      ),
    );
  }
}

/// Budget validation result
class BudgetValidationResult {
  final String metric;
  final dynamic value;
  final dynamic target;
  final dynamic warning;
  final dynamic critical;
  final bool isValid;
  final BudgetViolationSeverity severity;
  final String message;

  BudgetValidationResult({
    required this.metric,
    required this.value,
    this.target,
    this.warning,
    this.critical,
    required this.isValid,
    required this.severity,
    required this.message,
  });

  @override
  String toString() {
    return 'BudgetValidationResult('
        'metric: $metric, '
        'value: $value, '
        'isValid: $isValid, '
        'severity: $severity'
        ')';
  }
}

/// Budget violation severity levels
enum BudgetViolationSeverity {
  none,
  warning,
  critical,
  error,
}

/// Budget validation report
class BudgetValidationReport {
  final List<BudgetValidationResult> results;
  final String? platform;
  final String? deviceType;
  final DateTime timestamp;

  BudgetValidationReport({
    required this.results,
    this.platform,
    this.deviceType,
    required this.timestamp,
  });

  bool get allMetricsValid => results.every((r) => r.isValid);

  List<BudgetValidationResult> get criticalViolations => results
      .where((r) => r.severity == BudgetViolationSeverity.critical)
      .toList();

  List<BudgetValidationResult> get errorViolations => results
      .where((r) => r.severity == BudgetViolationSeverity.error)
      .toList();

  List<BudgetValidationResult> get warningViolations => results
      .where((r) => r.severity == BudgetViolationSeverity.warning)
      .toList();
}

/// Performance regression
class PerformanceRegression {
  final String metric;
  final dynamic baselineValue;
  final dynamic currentValue;
  final double percentageIncrease;
  final PerformanceRegressionSeverity severity;
  final double threshold;

  PerformanceRegression({
    required this.metric,
    required this.baselineValue,
    required this.currentValue,
    required this.percentageIncrease,
    required this.severity,
    required this.threshold,
  });

  @override
  String toString() {
    return 'PerformanceRegression('
        'metric: $metric, '
        'increase: ${percentageIncrease.toStringAsFixed(1)}%, '
        'severity: $severity'
        ')';
  }
}

/// Performance regression severity
enum PerformanceRegressionSeverity {
  minor,
  significant,
}

/// Budget summary
class BudgetSummary {
  final int totalMetrics;
  final int passedMetrics;
  final int failedMetrics;
  final int criticalViolations;
  final int errorViolations;
  final int warningViolations;
  final double passRate;

  BudgetSummary({
    required this.totalMetrics,
    required this.passedMetrics,
    required this.failedMetrics,
    required this.criticalViolations,
    required this.errorViolations,
    required this.warningViolations,
    required this.passRate,
  });

  bool get isHealthy => criticalViolations == 0 && errorViolations == 0;

  @override
  String toString() {
    return 'BudgetSummary('
        'passRate: ${passRate.toStringAsFixed(1)}%, '
        'critical: $criticalViolations, '
        'errors: $errorViolations, '
        'warnings: $warningViolations'
        ')';
  }
}

/// Performance budget report
class PerformanceBudgetReport {
  final BudgetValidationReport validationReport;
  final List<PerformanceRegression> regressions;
  final BudgetSummary summary;

  PerformanceBudgetReport({
    required this.validationReport,
    required this.regressions,
    required this.summary,
  });

  bool get isHealthy => summary.isHealthy && regressions.isEmpty;

  @override
  String toString() {
    return 'PerformanceBudgetReport('
        'summary: $summary, '
        'regressions: ${regressions.length}, '
        'healthy: $isHealthy'
        ')';
  }
}
