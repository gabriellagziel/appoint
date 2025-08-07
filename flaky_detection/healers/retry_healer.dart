import 'dart:async';
import 'dart:math';

/// Retry Healer for Flaky Tests
///
/// Automatically retries flaky tests with intelligent strategies:
/// - Exponential backoff retry strategy
/// - Adaptive retry limits based on test history
/// - Smart retry conditions
/// - Performance monitoring and optimization
class RetryHealer {
  static const int _defaultMaxRetries = 3;
  static const Duration _defaultInitialDelay = Duration(milliseconds: 100);
  static const double _defaultBackoffMultiplier = 2.0;
  static const Duration _defaultMaxDelay = Duration(seconds: 30);

  /// Heals a flaky test using retry strategy
  static Future<HealingResult> healFlakyTest({
    required String testName,
    required Future<bool> Function() testFunction,
    required FlakyPattern pattern,
    RetryStrategy? strategy,
  }) async {
    final healingStrategy = strategy ?? _createDefaultStrategy(pattern);
    final startTime = DateTime.now();

    try {
      // First attempt
      bool result = await testFunction();
      if (result) {
        return HealingResult(
          success: true,
          strategy: healingStrategy,
          attempts: 1,
          totalTime: DateTime.now().difference(startTime),
          confidence: 1.0,
          reason: 'Test passed on first attempt',
        );
      }

      // Retry attempts
      for (int attempt = 1; attempt <= healingStrategy.maxRetries; attempt++) {
        // Calculate delay
        final delay = _calculateDelay(attempt, healingStrategy);

        // Wait before retry
        await Future.delayed(delay);

        // Execute test
        result = await testFunction();

        if (result) {
          return HealingResult(
            success: true,
            strategy: healingStrategy,
            attempts: attempt + 1,
            totalTime: DateTime.now().difference(startTime),
            confidence: _calculateConfidence(attempt, healingStrategy),
            reason: 'Test passed after ${attempt + 1} attempts',
          );
        }

        // Check if we should continue based on pattern
        if (!_shouldContinueRetry(attempt, pattern, healingStrategy)) {
          break;
        }
      }

      // All retries failed
      return HealingResult(
        success: false,
        strategy: healingStrategy,
        attempts: healingStrategy.maxRetries + 1,
        totalTime: DateTime.now().difference(startTime),
        confidence: 0.0,
        reason: 'Test failed after ${healingStrategy.maxRetries + 1} attempts',
      );
    } catch (e) {
      return HealingResult(
        success: false,
        strategy: healingStrategy,
        attempts: 1,
        totalTime: DateTime.now().difference(startTime),
        confidence: 0.0,
        reason: 'Test execution error: $e',
      );
    }
  }

  /// Heals multiple flaky tests in parallel
  static Future<List<HealingResult>> healFlakyTests({
    required Map<String, Future<bool> Function()> testFunctions,
    required Map<String, FlakyPattern> patterns,
    Map<String, RetryStrategy>? strategies,
  }) async {
    final results = <HealingResult>[];
    final futures = <Future<HealingResult>>[];

    for (final entry in testFunctions.entries) {
      final testName = entry.key;
      final testFunction = entry.value;
      final pattern = patterns[testName]!;
      final strategy = strategies?[testName];

      futures.add(healFlakyTest(
        testName: testName,
        testFunction: testFunction,
        pattern: pattern,
        strategy: strategy,
      ));
    }

    // Execute all healing attempts in parallel
    final healingResults = await Future.wait(futures);
    results.addAll(healingResults);

    return results;
  }

  /// Creates default retry strategy based on flaky pattern
  static RetryStrategy _createDefaultStrategy(FlakyPattern pattern) {
    switch (pattern.type) {
      case FlakyPatternType.timing:
        return RetryStrategy(
          maxRetries: 5,
          initialDelay: Duration(milliseconds: 200),
          backoffMultiplier: 1.5,
          maxDelay: Duration(seconds: 10),
          jitter: true,
          adaptive: true,
        );

      case FlakyPatternType.intermittent:
        return RetryStrategy(
          maxRetries: 3,
          initialDelay: Duration(milliseconds: 100),
          backoffMultiplier: 2.0,
          maxDelay: Duration(seconds: 5),
          jitter: false,
          adaptive: false,
        );

      case FlakyPatternType.consecutive:
        return RetryStrategy(
          maxRetries: 4,
          initialDelay: Duration(milliseconds: 500),
          backoffMultiplier: 2.5,
          maxDelay: Duration(seconds: 15),
          jitter: true,
          adaptive: true,
        );

      case FlakyPatternType.timeBased:
        return RetryStrategy(
          maxRetries: 6,
          initialDelay: Duration(seconds: 1),
          backoffMultiplier: 2.0,
          maxDelay: Duration(seconds: 30),
          jitter: true,
          adaptive: true,
        );

      case FlakyPatternType.variable:
        return RetryStrategy(
          maxRetries: 4,
          initialDelay: Duration(milliseconds: 300),
          backoffMultiplier: 1.8,
          maxDelay: Duration(seconds: 8),
          jitter: true,
          adaptive: true,
        );
    }
  }

  /// Calculates delay for retry attempt
  static Duration _calculateDelay(int attempt, RetryStrategy strategy) {
    // Base delay with exponential backoff
    double delayMs = strategy.initialDelay.inMilliseconds *
        pow(strategy.backoffMultiplier, attempt - 1);

    // Apply maximum delay limit
    delayMs = delayMs.clamp(0.0, strategy.maxDelay.inMilliseconds.toDouble());

    // Apply jitter if enabled
    if (strategy.jitter) {
      final jitterFactor = 0.1 + (Random().nextDouble() * 0.2); // 10-30% jitter
      delayMs *= jitterFactor;
    }

    return Duration(milliseconds: delayMs.round());
  }

  /// Determines if retry should continue based on pattern
  static bool _shouldContinueRetry(
    int attempt,
    FlakyPattern pattern,
    RetryStrategy strategy,
  ) {
    // Check if we've reached max retries
    if (attempt >= strategy.maxRetries) {
      return false;
    }

    // Pattern-specific retry logic
    switch (pattern.type) {
      case FlakyPatternType.timing:
        // For timing issues, continue retrying with longer delays
        return true;

      case FlakyPatternType.intermittent:
        // For intermittent issues, limit retries to avoid excessive delays
        return attempt < 3;

      case FlakyPatternType.consecutive:
        // For consecutive failures, be more aggressive with retries
        return attempt < 5;

      case FlakyPatternType.timeBased:
        // For time-based issues, continue retrying with longer delays
        return true;

      case FlakyPatternType.variable:
        // For variable issues, use adaptive retry logic
        return _adaptiveRetryLogic(attempt, pattern, strategy);
    }
  }

  /// Adaptive retry logic for variable flaky patterns
  static bool _adaptiveRetryLogic(
    int attempt,
    FlakyPattern pattern,
    RetryStrategy strategy,
  ) {
    if (!strategy.adaptive) {
      return attempt < strategy.maxRetries;
    }

    // Adaptive logic based on pattern confidence
    final confidenceFactor = pattern.confidence;
    final adaptiveMaxRetries = (strategy.maxRetries * confidenceFactor).round();

    return attempt < adaptiveMaxRetries;
  }

  /// Calculates confidence in healing success
  static double _calculateConfidence(int attempts, RetryStrategy strategy) {
    // Base confidence decreases with more attempts
    double confidence = 1.0 - (attempts / (strategy.maxRetries + 1));

    // Adjust based on strategy type
    if (strategy.adaptive) {
      confidence *= 1.2; // Adaptive strategies are more effective
    }

    if (strategy.jitter) {
      confidence *= 1.1; // Jitter helps with timing issues
    }

    return confidence.clamp(0.0, 1.0);
  }

  /// Creates adaptive retry strategy based on test history
  static RetryStrategy createAdaptiveStrategy({
    required String testName,
    required List<TestExecutionHistory> history,
    required FlakyPattern pattern,
  }) {
    // Analyze historical retry success
    final retrySuccessRate = _analyzeRetrySuccessRate(history);
    final avgRetriesToSuccess = _analyzeAvgRetriesToSuccess(history);
    final failurePattern = _analyzeFailurePattern(history);

    // Adjust strategy based on history
    int maxRetries = _defaultMaxRetries;
    Duration initialDelay = _defaultInitialDelay;
    double backoffMultiplier = _defaultBackoffMultiplier;

    // Adjust based on retry success rate
    if (retrySuccessRate > 0.8) {
      maxRetries = 5;
      initialDelay = Duration(milliseconds: 50);
    } else if (retrySuccessRate < 0.3) {
      maxRetries = 2;
      initialDelay = Duration(milliseconds: 200);
    }

    // Adjust based on average retries to success
    if (avgRetriesToSuccess > 2) {
      maxRetries = max(maxRetries, avgRetriesToSuccess + 1);
    }

    // Adjust based on failure pattern
    if (failurePattern == FailurePatternType.timing) {
      initialDelay = Duration(milliseconds: 300);
      backoffMultiplier = 2.5;
    } else if (failurePattern == FailurePatternType.intermittent) {
      backoffMultiplier = 1.5;
    }

    return RetryStrategy(
      maxRetries: maxRetries,
      initialDelay: initialDelay,
      backoffMultiplier: backoffMultiplier,
      maxDelay: Duration(seconds: 30),
      jitter: true,
      adaptive: true,
    );
  }

  /// Analyzes retry success rate from history
  static double _analyzeRetrySuccessRate(List<TestExecutionHistory> history) {
    if (history.isEmpty) return 0.5;

    int totalRetries = 0;
    int successfulRetries = 0;

    for (final h in history) {
      if (h.retryAttempts > 0) {
        totalRetries += h.retryAttempts;
        if (h.finalResult) {
          successfulRetries += h.retryAttempts;
        }
      }
    }

    return totalRetries > 0 ? successfulRetries / totalRetries : 0.5;
  }

  /// Analyzes average retries to success
  static double _analyzeAvgRetriesToSuccess(
      List<TestExecutionHistory> history) {
    if (history.isEmpty) return 1.0;

    final successfulRetries = history
        .where((h) => h.finalResult && h.retryAttempts > 0)
        .map((h) => h.retryAttempts)
        .toList();

    if (successfulRetries.isEmpty) return 1.0;

    final sum = successfulRetries.reduce((a, b) => a + b);
    return sum / successfulRetries.length;
  }

  /// Analyzes failure pattern from history
  static FailurePatternType _analyzeFailurePattern(
      List<TestExecutionHistory> history) {
    if (history.length < 3) return FailurePatternType.intermittent;

    // Look for timing patterns
    final executionTimes =
        history.map((h) => h.executionTime.inMilliseconds).toList();
    final timeVariance = _calculateVariance(executionTimes);
    final avgTime =
        executionTimes.reduce((a, b) => a + b) / executionTimes.length;
    final timeVarianceRatio = timeVariance / (avgTime * avgTime);

    if (timeVarianceRatio > 0.5) {
      return FailurePatternType.timing;
    }

    // Look for consecutive patterns
    final results = history.map((h) => h.finalResult).toList();
    final consecutiveFailures = _calculateMaxConsecutiveFailures(results);

    if (consecutiveFailures > 2) {
      return FailurePatternType.consecutive;
    }

    return FailurePatternType.intermittent;
  }

  /// Calculates variance of a list of values
  static double _calculateVariance(List<int> values) {
    if (values.isEmpty) return 0.0;

    final mean = values.reduce((a, b) => a + b) / values.length;
    final squaredDifferences =
        values.map((value) => (value - mean) * (value - mean));
    final sum = squaredDifferences.reduce((a, b) => a + b);

    return sum / values.length;
  }

  /// Calculates maximum consecutive failures
  static int _calculateMaxConsecutiveFailures(List<bool> results) {
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

  /// Monitors healing performance and provides insights
  static Future<HealingInsights> analyzeHealingPerformance({
    required List<HealingResult> results,
    required Duration timeWindow,
  }) async {
    if (results.isEmpty) {
      return HealingInsights.empty();
    }

    final successfulHealings = results.where((r) => r.success).toList();
    final failedHealings = results.where((r) => !r.success).toList();

    final successRate = successfulHealings.length / results.length;
    final avgAttempts =
        results.map((r) => r.attempts).reduce((a, b) => a + b) / results.length;
    final avgHealingTime =
        results.map((r) => r.totalTime.inMilliseconds).reduce((a, b) => a + b) /
            results.length;

    // Strategy effectiveness analysis
    final strategyEffectiveness = <String, double>{};
    final strategies = results.map((r) => r.strategy.name).toSet();

    for (final strategy in strategies) {
      final strategyResults =
          results.where((r) => r.strategy.name == strategy).toList();
      final strategySuccessRate =
          strategyResults.where((r) => r.success).length /
              strategyResults.length;
      strategyEffectiveness[strategy] = strategySuccessRate;
    }

    // Pattern effectiveness analysis
    final patternEffectiveness = <FlakyPatternType, double>{};
    final patterns = results
        .map((r) => r.pattern?.type)
        .whereType<FlakyPatternType>()
        .toSet();

    for (final pattern in patterns) {
      final patternResults =
          results.where((r) => r.pattern?.type == pattern).toList();
      final patternSuccessRate =
          patternResults.where((r) => r.success).length / patternResults.length;
      patternEffectiveness[pattern] = patternSuccessRate;
    }

    return HealingInsights(
      totalHealings: results.length,
      successfulHealings: successfulHealings.length,
      failedHealings: failedHealings.length,
      successRate: successRate,
      avgAttempts: avgAttempts,
      avgHealingTime: Duration(milliseconds: avgHealingTime.round()),
      strategyEffectiveness: strategyEffectiveness,
      patternEffectiveness: patternEffectiveness,
      recommendations: _generateRecommendations(results, successRate),
    );
  }

  /// Generates recommendations based on healing performance
  static List<String> _generateRecommendations(
    List<HealingResult> results,
    double successRate,
  ) {
    final recommendations = <String>[];

    if (successRate < 0.5) {
      recommendations
          .add('Consider reducing retry attempts to avoid excessive delays');
      recommendations.add(
          'Investigate root cause of flaky tests instead of relying on retries');
    }

    if (successRate > 0.8) {
      recommendations
          .add('Retry strategy is effective, consider increasing retry limits');
    }

    final avgAttempts =
        results.map((r) => r.attempts).reduce((a, b) => a + b) / results.length;
    if (avgAttempts > 3) {
      recommendations
          .add('High average retry attempts suggest timing or resource issues');
    }

    return recommendations;
  }
}

/// Retry strategy configuration
class RetryStrategy {
  final int maxRetries;
  final Duration initialDelay;
  final double backoffMultiplier;
  final Duration maxDelay;
  final bool jitter;
  final bool adaptive;
  final String name;

  RetryStrategy({
    required this.maxRetries,
    required this.initialDelay,
    required this.backoffMultiplier,
    required this.maxDelay,
    required this.jitter,
    required this.adaptive,
    String? name,
  }) : name = name ?? _generateStrategyName();

  static String _generateStrategyName() {
    return 'RetryStrategy_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  String toString() {
    return 'RetryStrategy('
        'maxRetries: $maxRetries, '
        'initialDelay: ${initialDelay.inMilliseconds}ms, '
        'backoffMultiplier: $backoffMultiplier, '
        'jitter: $jitter, '
        'adaptive: $adaptive'
        ')';
  }
}

/// Healing result
class HealingResult {
  final bool success;
  final RetryStrategy strategy;
  final int attempts;
  final Duration totalTime;
  final double confidence;
  final String reason;
  final FlakyPattern? pattern;

  HealingResult({
    required this.success,
    required this.strategy,
    required this.attempts,
    required this.totalTime,
    required this.confidence,
    required this.reason,
    this.pattern,
  });

  @override
  String toString() {
    return 'HealingResult('
        'success: $success, '
        'attempts: $attempts, '
        'totalTime: ${totalTime.inMilliseconds}ms, '
        'confidence: ${confidence.toStringAsFixed(2)}, '
        'reason: $reason'
        ')';
  }
}

/// Test execution history for adaptive strategies
class TestExecutionHistory {
  final bool finalResult;
  final int retryAttempts;
  final Duration executionTime;
  final DateTime timestamp;

  TestExecutionHistory({
    required this.finalResult,
    required this.retryAttempts,
    required this.executionTime,
    required this.timestamp,
  });
}

/// Healing insights and performance analysis
class HealingInsights {
  final int totalHealings;
  final int successfulHealings;
  final int failedHealings;
  final double successRate;
  final double avgAttempts;
  final Duration avgHealingTime;
  final Map<String, double> strategyEffectiveness;
  final Map<FlakyPatternType, double> patternEffectiveness;
  final List<String> recommendations;

  HealingInsights({
    required this.totalHealings,
    required this.successfulHealings,
    required this.failedHealings,
    required this.successRate,
    required this.avgAttempts,
    required this.avgHealingTime,
    required this.strategyEffectiveness,
    required this.patternEffectiveness,
    required this.recommendations,
  });

  factory HealingInsights.empty() {
    return HealingInsights(
      totalHealings: 0,
      successfulHealings: 0,
      failedHealings: 0,
      successRate: 0.0,
      avgAttempts: 0.0,
      avgHealingTime: Duration.zero,
      strategyEffectiveness: {},
      patternEffectiveness: {},
      recommendations: [],
    );
  }

  @override
  String toString() {
    return 'HealingInsights('
        'totalHealings: $totalHealings, '
        'successRate: ${(successRate * 100).toStringAsFixed(1)}%, '
        'avgAttempts: ${avgAttempts.toStringAsFixed(1)}, '
        'avgHealingTime: ${avgHealingTime.inMilliseconds}ms'
        ')';
  }
}

/// Failure pattern types
enum FailurePatternType {
  timing,
  consecutive,
  intermittent,
}
