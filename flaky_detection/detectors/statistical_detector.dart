import 'dart:math';

/// Statistical Flaky Test Detector
///
/// Uses statistical methods to detect flaky tests:
/// - Analyzes test execution patterns
/// - Calculates statistical measures of flakiness
/// - Identifies flaky test patterns
/// - Provides confidence levels for flaky test detection
class StatisticalDetector {
  static const double _defaultConfidenceThreshold = 0.95;
  static const int _minimumExecutions = 10;
  static const double _flakyThreshold =
      0.1; // 10% failure rate for flaky detection

  /// Detects flaky tests using statistical analysis
  static Future<FlakyTestResult> detectFlakyTest({
    required String testName,
    required List<TestExecution> executions,
    double confidenceThreshold = _defaultConfidenceThreshold,
  }) async {
    try {
      // Validate input
      if (executions.length < _minimumExecutions) {
        return FlakyTestResult(
          testName: testName,
          isFlaky: false,
          confidence: 0.0,
          reason:
              'Insufficient execution data (${executions.length} < $_minimumExecutions)',
          statisticalMeasures: StatisticalMeasures.empty(),
        );
      }

      // Calculate statistical measures
      final measures = _calculateStatisticalMeasures(executions);

      // Detect flaky patterns
      final patterns = _detectFlakyPatterns(executions, measures);

      // Determine if test is flaky
      final isFlaky = _isFlaky(measures, patterns);

      // Calculate confidence
      final confidence =
          _calculateConfidence(measures, patterns, executions.length);

      // Generate reason
      final reason = _generateReason(measures, patterns, isFlaky);

      return FlakyTestResult(
        testName: testName,
        isFlaky: isFlaky,
        confidence: confidence,
        reason: reason,
        statisticalMeasures: measures,
        patterns: patterns,
      );
    } catch (e) {
      return FlakyTestResult(
        testName: testName,
        isFlaky: false,
        confidence: 0.0,
        reason: 'Error in statistical analysis: $e',
        statisticalMeasures: StatisticalMeasures.empty(),
      );
    }
  }

  /// Detects flaky tests in a batch
  static Future<List<FlakyTestResult>> detectFlakyTests({
    required Map<String, List<TestExecution>> testExecutions,
    double confidenceThreshold = _defaultConfidenceThreshold,
  }) async {
    final results = <FlakyTestResult>[];

    for (final entry in testExecutions.entries) {
      final testName = entry.key;
      final executions = entry.value;

      final result = await detectFlakyTest(
        testName: testName,
        executions: executions,
        confidenceThreshold: confidenceThreshold,
      );

      results.add(result);
    }

    // Sort by confidence (highest first)
    results.sort((a, b) => b.confidence.compareTo(a.confidence));

    return results;
  }

  /// Calculates statistical measures for test executions
  static StatisticalMeasures _calculateStatisticalMeasures(
      List<TestExecution> executions) {
    final results = executions.map((e) => e.passed).toList();
    final executionTimes =
        executions.map((e) => e.executionTime.inMilliseconds).toList();

    // Basic statistics
    final totalExecutions = results.length;
    final passedExecutions = results.where((r) => r).length;
    final failedExecutions = totalExecutions - passedExecutions;
    final passRate = passedExecutions / totalExecutions;
    final failureRate = failedExecutions / totalExecutions;

    // Execution time statistics
    final avgExecutionTime =
        executionTimes.reduce((a, b) => a + b) / executionTimes.length;
    final minExecutionTime = executionTimes.reduce((a, b) => a < b ? a : b);
    final maxExecutionTime = executionTimes.reduce((a, b) => a > b ? a : b);
    final executionTimeVariance =
        _calculateVariance(executionTimes, avgExecutionTime);
    final executionTimeStdDev = sqrt(executionTimeVariance);

    // Failure pattern analysis
    final failurePatterns = _analyzeFailurePatterns(results);
    final consecutiveFailures = REDACTED_TOKEN(results);
    final consecutivePasses = _calculateMaxConsecutivePasses(results);

    // Time-based analysis
    final timeBasedPatterns = _analyzeTimeBasedPatterns(executions);

    // Variance in results
    final resultVariance = _calculateResultVariance(results);

    return StatisticalMeasures(
      totalExecutions: totalExecutions,
      passedExecutions: passedExecutions,
      failedExecutions: failedExecutions,
      passRate: passRate,
      failureRate: failureRate,
      avgExecutionTime: avgExecutionTime,
      minExecutionTime: minExecutionTime,
      maxExecutionTime: maxExecutionTime,
      executionTimeVariance: executionTimeVariance,
      executionTimeStdDev: executionTimeStdDev,
      consecutiveFailures: consecutiveFailures,
      consecutivePasses: consecutivePasses,
      resultVariance: resultVariance,
      failurePatterns: failurePatterns,
      timeBasedPatterns: timeBasedPatterns,
    );
  }

  /// Detects flaky patterns in test executions
  static List<FlakyPattern> _detectFlakyPatterns(
    List<TestExecution> executions,
    StatisticalMeasures measures,
  ) {
    final patterns = <FlakyPattern>[];

    // Pattern 1: Intermittent failures
    if (measures.failureRate > _flakyThreshold && measures.failureRate < 0.5) {
      patterns.add(FlakyPattern(
        type: FlakyPatternType.intermittent,
        confidence: _calculatePatternConfidence(
            measures.failureRate, measures.totalExecutions),
        description:
            'Intermittent failures with ${(measures.failureRate * 100).toStringAsFixed(1)}% failure rate',
      ));
    }

    // Pattern 2: High execution time variance
    final timeVarianceRatio = measures.executionTimeVariance /
        (measures.avgExecutionTime * measures.avgExecutionTime);
    if (timeVarianceRatio > 0.5) {
      patterns.add(FlakyPattern(
        type: FlakyPatternType.timing,
        confidence: _calculatePatternConfidence(
            timeVarianceRatio, measures.totalExecutions),
        description:
            'High execution time variance (${timeVarianceRatio.toStringAsFixed(2)})',
      ));
    }

    // Pattern 3: Consecutive failures
    if (measures.consecutiveFailures > 2) {
      patterns.add(FlakyPattern(
        type: FlakyPatternType.consecutive,
        confidence: _calculatePatternConfidence(
            measures.consecutiveFailures / 10.0, measures.totalExecutions),
        description:
            'Consecutive failures (max: ${measures.consecutiveFailures})',
      ));
    }

    // Pattern 4: Time-based patterns
    for (final timePattern in measures.timeBasedPatterns) {
      patterns.add(FlakyPattern(
        type: FlakyPatternType.timeBased,
        confidence: timePattern.confidence,
        description: 'Time-based pattern: ${timePattern.description}',
      ));
    }

    // Pattern 5: High result variance
    if (measures.resultVariance > 0.2) {
      patterns.add(FlakyPattern(
        type: FlakyPatternType.variable,
        confidence: _calculatePatternConfidence(
            measures.resultVariance, measures.totalExecutions),
        description:
            'High result variance (${measures.resultVariance.toStringAsFixed(2)})',
      ));
    }

    return patterns;
  }

  /// Determines if a test is flaky based on statistical measures
  static bool _isFlaky(
      StatisticalMeasures measures, List<FlakyPattern> patterns) {
    // Multiple indicators of flakiness
    int flakyIndicators = 0;

    // Indicator 1: Failure rate in flaky range
    if (measures.failureRate > _flakyThreshold && measures.failureRate < 0.5) {
      flakyIndicators++;
    }

    // Indicator 2: High execution time variance
    final timeVarianceRatio = measures.executionTimeVariance /
        (measures.avgExecutionTime * measures.avgExecutionTime);
    if (timeVarianceRatio > 0.5) {
      flakyIndicators++;
    }

    // Indicator 3: Consecutive failures
    if (measures.consecutiveFailures > 2) {
      flakyIndicators++;
    }

    // Indicator 4: High result variance
    if (measures.resultVariance > 0.2) {
      flakyIndicators++;
    }

    // Indicator 5: Time-based patterns
    if (measures.timeBasedPatterns.isNotEmpty) {
      flakyIndicators++;
    }

    // Test is considered flaky if it has at least 2 indicators
    return flakyIndicators >= 2;
  }

  /// Calculates confidence in flaky test detection
  static double _calculateConfidence(
    StatisticalMeasures measures,
    List<FlakyPattern> patterns,
    int totalExecutions,
  ) {
    double confidence = 0.0;

    // Base confidence from number of executions
    confidence += (totalExecutions / 100.0).clamp(0.0, 0.3);

    // Confidence from failure rate
    if (measures.failureRate > _flakyThreshold && measures.failureRate < 0.5) {
      confidence += 0.3;
    }

    // Confidence from patterns
    for (final pattern in patterns) {
      confidence += pattern.confidence * 0.1;
    }

    // Confidence from execution time variance
    final timeVarianceRatio = measures.executionTimeVariance /
        (measures.avgExecutionTime * measures.avgExecutionTime);
    if (timeVarianceRatio > 0.5) {
      confidence += 0.2;
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Generates reason for flaky test detection
  static String _generateReason(
    StatisticalMeasures measures,
    List<FlakyPattern> patterns,
    bool isFlaky,
  ) {
    if (!isFlaky) {
      return 'Test shows consistent behavior with ${(measures.passRate * 100).toStringAsFixed(1)}% pass rate';
    }

    final reasons = <String>[];

    if (measures.failureRate > _flakyThreshold) {
      reasons.add(
          '${(measures.failureRate * 100).toStringAsFixed(1)}% failure rate');
    }

    if (measures.consecutiveFailures > 2) {
      reasons.add('${measures.consecutiveFailures} consecutive failures');
    }

    final timeVarianceRatio = measures.executionTimeVariance /
        (measures.avgExecutionTime * measures.avgExecutionTime);
    if (timeVarianceRatio > 0.5) {
      reasons.add('high execution time variance');
    }

    if (patterns.isNotEmpty) {
      reasons.add('${patterns.length} flaky patterns detected');
    }

    return 'Flaky test detected: ${reasons.join(', ')}';
  }

  /// Calculates variance of a list of values
  static double _calculateVariance(List<int> values, double mean) {
    if (values.isEmpty) return 0.0;

    final squaredDifferences =
        values.map((value) => (value - mean) * (value - mean));
    final sum = squaredDifferences.reduce((a, b) => a + b);

    return sum / values.length;
  }

  /// Calculates variance of boolean results
  static double _calculateResultVariance(List<bool> results) {
    if (results.isEmpty) return 0.0;

    final passCount = results.where((r) => r).length;

    // Variance for binary outcomes
    final p = passCount / results.length;
    return p * (1 - p);
  }

  /// Analyzes failure patterns
  static List<FailurePattern> _analyzeFailurePatterns(List<bool> results) {
    final patterns = <FailurePattern>[];

    // Look for alternating patterns
    int alternations = 0;
    for (int i = 1; i < results.length; i++) {
      if (results[i] != results[i - 1]) {
        alternations++;
      }
    }

    final alternationRate = alternations / (results.length - 1);
    if (alternationRate > 0.7) {
      patterns.add(FailurePattern(
        type: FailurePatternType.alternating,
        frequency: alternationRate,
        description:
            'High alternation rate (${(alternationRate * 100).toStringAsFixed(1)}%)',
      ));
    }

    // Look for clustering patterns
    final clusters = _findFailureClusters(results);
    if (clusters.length > 2) {
      patterns.add(FailurePattern(
        type: FailurePatternType.clustered,
        frequency: clusters.length / results.length.toDouble(),
        description: '${clusters.length} failure clusters detected',
      ));
    }

    return patterns;
  }

  /// Finds failure clusters in results
  static List<int> _findFailureClusters(List<bool> results) {
    final clusters = <int>[];
    int currentCluster = 0;

    for (final result in results) {
      if (!result) {
        currentCluster++;
      } else if (currentCluster > 0) {
        clusters.add(currentCluster);
        currentCluster = 0;
      }
    }

    if (currentCluster > 0) {
      clusters.add(currentCluster);
    }

    return clusters;
  }

  /// Calculates maximum consecutive failures
  static int REDACTED_TOKEN(List<bool> results) {
    int maxConsecutive = 0;
    int currentConsecutive = 0;

    for (final result in results) {
      if (!result) {
        currentConsecutive++;
        maxConsecutive = max(maxConsecutive, currentConsecutive);
      } else {
        currentConsecutive = 0;
      }
    }

    return maxConsecutive;
  }

  /// Calculates maximum consecutive passes
  static int _calculateMaxConsecutivePasses(List<bool> results) {
    int maxConsecutive = 0;
    int currentConsecutive = 0;

    for (final result in results) {
      if (result) {
        currentConsecutive++;
        maxConsecutive = max(maxConsecutive, currentConsecutive);
      } else {
        currentConsecutive = 0;
      }
    }

    return maxConsecutive;
  }

  /// Analyzes time-based patterns
  static List<TimeBasedPattern> _analyzeTimeBasedPatterns(
      List<TestExecution> executions) {
    final patterns = <TimeBasedPattern>[];

    // Group by time of day
    final timeGroups = <int, List<TestExecution>>{};
    for (final execution in executions) {
      final hour = execution.timestamp.hour;
      timeGroups.putIfAbsent(hour, () => []).add(execution);
    }

    // Check for time-of-day patterns
    for (final entry in timeGroups.entries) {
      final hour = entry.key;
      final groupExecutions = entry.value;

      if (groupExecutions.length >= 3) {
        final passRate = groupExecutions.where((e) => e.passed).length /
            groupExecutions.length;

        if (passRate < 0.8 || passRate > 0.95) {
          patterns.add(TimeBasedPattern(
            type: TimeBasedPatternType.timeOfDay,
            confidence: _calculatePatternConfidence(
                (1 - passRate).abs(), groupExecutions.length),
            description:
                'Hour $hour: ${(passRate * 100).toStringAsFixed(1)}% pass rate',
          ));
        }
      }
    }

    // Check for day-of-week patterns
    final dayGroups = <int, List<TestExecution>>{};
    for (final execution in executions) {
      final day = execution.timestamp.weekday;
      dayGroups.putIfAbsent(day, () => []).add(execution);
    }

    for (final entry in dayGroups.entries) {
      final day = entry.key;
      final groupExecutions = entry.value;

      if (groupExecutions.length >= 3) {
        final passRate = groupExecutions.where((e) => e.passed).length /
            groupExecutions.length;

        if (passRate < 0.8 || passRate > 0.95) {
          patterns.add(TimeBasedPattern(
            type: TimeBasedPatternType.dayOfWeek,
            confidence: _calculatePatternConfidence(
                (1 - passRate).abs(), groupExecutions.length),
            description:
                'Day $day: ${(passRate * 100).toStringAsFixed(1)}% pass rate',
          ));
        }
      }
    }

    return patterns;
  }

  /// Calculates pattern confidence
  static double _calculatePatternConfidence(double strength, int sampleSize) {
    // Base confidence on pattern strength and sample size
    final baseConfidence = strength.clamp(0.0, 1.0);
    final sampleConfidence = (sampleSize / 20.0).clamp(0.0, 1.0);

    return (baseConfidence + sampleConfidence) / 2.0;
  }
}

/// Test execution data
class TestExecution {
  final bool passed;
  final Duration executionTime;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  TestExecution({
    required this.passed,
    required this.executionTime,
    required this.timestamp,
    this.metadata = const {},
  });
}

/// Flaky test detection result
class FlakyTestResult {
  final String testName;
  final bool isFlaky;
  final double confidence;
  final String reason;
  final StatisticalMeasures statisticalMeasures;
  final List<FlakyPattern> patterns;

  FlakyTestResult({
    required this.testName,
    required this.isFlaky,
    required this.confidence,
    required this.reason,
    required this.statisticalMeasures,
    this.patterns = const [],
  });

  @override
  String toString() {
    return 'FlakyTestResult('
        'test: $testName, '
        'isFlaky: $isFlaky, '
        'confidence: ${confidence.toStringAsFixed(2)}, '
        'reason: $reason'
        ')';
  }
}

/// Statistical measures for test analysis
class StatisticalMeasures {
  final int totalExecutions;
  final int passedExecutions;
  final int failedExecutions;
  final double passRate;
  final double failureRate;
  final double avgExecutionTime;
  final int minExecutionTime;
  final int maxExecutionTime;
  final double executionTimeVariance;
  final double executionTimeStdDev;
  final int consecutiveFailures;
  final int consecutivePasses;
  final double resultVariance;
  final List<FailurePattern> failurePatterns;
  final List<TimeBasedPattern> timeBasedPatterns;

  StatisticalMeasures({
    required this.totalExecutions,
    required this.passedExecutions,
    required this.failedExecutions,
    required this.passRate,
    required this.failureRate,
    required this.avgExecutionTime,
    required this.minExecutionTime,
    required this.maxExecutionTime,
    required this.executionTimeVariance,
    required this.executionTimeStdDev,
    required this.consecutiveFailures,
    required this.consecutivePasses,
    required this.resultVariance,
    required this.failurePatterns,
    required this.timeBasedPatterns,
  });

  factory StatisticalMeasures.empty() {
    return StatisticalMeasures(
      totalExecutions: 0,
      passedExecutions: 0,
      failedExecutions: 0,
      passRate: 0.0,
      failureRate: 0.0,
      avgExecutionTime: 0.0,
      minExecutionTime: 0,
      maxExecutionTime: 0,
      executionTimeVariance: 0.0,
      executionTimeStdDev: 0.0,
      consecutiveFailures: 0,
      consecutivePasses: 0,
      resultVariance: 0.0,
      failurePatterns: [],
      timeBasedPatterns: [],
    );
  }
}

/// Flaky pattern information
class FlakyPattern {
  final FlakyPatternType type;
  final double confidence;
  final String description;

  FlakyPattern({
    required this.type,
    required this.confidence,
    required this.description,
  });
}

/// Flaky pattern types
enum FlakyPatternType {
  intermittent,
  timing,
  consecutive,
  timeBased,
  variable,
}

/// Failure pattern information
class FailurePattern {
  final FailurePatternType type;
  final double frequency;
  final String description;

  FailurePattern({
    required this.type,
    required this.frequency,
    required this.description,
  });
}

/// Failure pattern types
enum FailurePatternType {
  alternating,
  clustered,
  random,
}

/// Time-based pattern information
class TimeBasedPattern {
  final TimeBasedPatternType type;
  final double confidence;
  final String description;

  TimeBasedPattern({
    required this.type,
    required this.confidence,
    required this.description,
  });
}

/// Time-based pattern types
enum TimeBasedPatternType {
  timeOfDay,
  dayOfWeek,
  seasonal,
}
