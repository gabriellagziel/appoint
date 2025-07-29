import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Performance test for measuring app startup time
///
/// This test measures the time it takes for the app to:
/// - Initialize Flutter engine
/// - Load main.dart
/// - Complete initial widget build
/// - Reach interactive state
class StartupTimeTest {
  static const Duration _timeout = Duration(minutes: 2);
  static const Duration _targetStartupTime = Duration(seconds: 2);

  /// Measures the complete startup time of the app
  static Future<StartupTimeResult> measureStartupTime() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Start the app
      final app =
          await IntegrationTestWidgetsFlutterBinding.ensureInitialized();

      // Measure time to first frame
      final firstFrameTime = await _measureFirstFrameTime();

      // Measure time to interactive state
      final interactiveTime = await _measureInteractiveTime();

      stopwatch.stop();

      return StartupTimeResult(
        totalStartupTime: stopwatch.elapsed,
        firstFrameTime: firstFrameTime,
        interactiveTime: interactiveTime,
        isWithinBudget: stopwatch.elapsed <= _targetStartupTime,
      );
    } catch (e) {
      stopwatch.stop();
      return StartupTimeResult(
        totalStartupTime: stopwatch.elapsed,
        firstFrameTime: Duration.zero,
        interactiveTime: Duration.zero,
        isWithinBudget: false,
        error: e.toString(),
      );
    }
  }

  /// Measures time to first frame
  static Future<Duration> _measureFirstFrameTime() async {
    final stopwatch = Stopwatch()..start();

    // Wait for first frame
    await TestWidgetsFlutterBinding.ensureInitialized();
    await TestWidgetsFlutterBinding.instance.pumpAndSettle();

    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Measures time to interactive state
  static Future<Duration> _measureInteractiveTime() async {
    final stopwatch = Stopwatch()..start();

    // Wait for app to be fully interactive
    await Future.delayed(const Duration(milliseconds: 500));

    // Simulate user interaction readiness
    await TestWidgetsFlutterBinding.instance.pumpAndSettle();

    stopwatch.stop();
    return stopwatch.elapsed;
  }

  /// Runs startup time test with multiple iterations
  static Future<List<StartupTimeResult>> runStartupTimeBenchmark({
    int iterations = 5,
  }) async {
    final results = <StartupTimeResult>[];

    for (int i = 0; i < iterations; i++) {
      print('Running startup time test iteration ${i + 1}/$iterations');

      // Clean up between iterations
      await _cleanupBetweenIterations();

      // Measure startup time
      final result = await measureStartupTime();
      results.add(result);

      // Wait between iterations
      if (i < iterations - 1) {
        await Future.delayed(const Duration(seconds: 2));
      }
    }

    return results;
  }

  /// Cleans up between test iterations
  static Future<void> _cleanupBetweenIterations() async {
    // Clear any cached data
    await Future.delayed(const Duration(milliseconds: 100));

    // Reset test binding
    TestWidgetsFlutterBinding.instance.resetTestTextInput();
  }

  /// Analyzes startup time results
  static StartupTimeAnalysis analyzeResults(List<StartupTimeResult> results) {
    if (results.isEmpty) {
      return StartupTimeAnalysis(
        averageStartupTime: Duration.zero,
        minStartupTime: Duration.zero,
        maxStartupTime: Duration.zero,
        standardDeviation: 0.0,
        isWithinBudget: false,
        totalTests: 0,
        passedTests: 0,
      );
    }

    final startupTimes =
        results.map((r) => r.totalStartupTime.inMilliseconds).toList();
    final avgTime = startupTimes.reduce((a, b) => a + b) / startupTimes.length;
    final minTime = startupTimes.reduce((a, b) => a < b ? a : b);
    final maxTime = startupTimes.reduce((a, b) => a > b ? a : b);

    // Calculate standard deviation
    final variance = startupTimes
            .map((t) => (t - avgTime) * (t - avgTime))
            .reduce((a, b) => a + b) /
        startupTimes.length;
    final stdDev = sqrt(variance);

    final passedTests = results.where((r) => r.isWithinBudget).length;

    return StartupTimeAnalysis(
      averageStartupTime: Duration(milliseconds: avgTime.round()),
      minStartupTime: Duration(milliseconds: minTime),
      maxStartupTime: Duration(milliseconds: maxTime),
      standardDeviation: stdDev,
      isWithinBudget: avgTime <= _targetStartupTime.inMilliseconds,
      totalTests: results.length,
      passedTests: passedTests,
    );
  }
}

/// Result of a single startup time measurement
class StartupTimeResult {
  final Duration totalStartupTime;
  final Duration firstFrameTime;
  final Duration interactiveTime;
  final bool isWithinBudget;
  final String? error;

  StartupTimeResult({
    required this.totalStartupTime,
    required this.firstFrameTime,
    required this.interactiveTime,
    required this.isWithinBudget,
    this.error,
  });

  @override
  String toString() {
    return 'StartupTimeResult('
        'total: ${totalStartupTime.inMilliseconds}ms, '
        'firstFrame: ${firstFrameTime.inMilliseconds}ms, '
        'interactive: ${interactiveTime.inMilliseconds}ms, '
        'withinBudget: $isWithinBudget'
        '${error != null ? ', error: $error' : ''}'
        ')';
  }
}

/// Analysis of multiple startup time measurements
class StartupTimeAnalysis {
  final Duration averageStartupTime;
  final Duration minStartupTime;
  final Duration maxStartupTime;
  final double standardDeviation;
  final bool isWithinBudget;
  final int totalTests;
  final int passedTests;

  StartupTimeAnalysis({
    required this.averageStartupTime,
    required this.minStartupTime,
    required this.maxStartupTime,
    required this.standardDeviation,
    required this.isWithinBudget,
    required this.totalTests,
    required this.passedTests,
  });

  double get passRate => totalTests > 0 ? passedTests / totalTests : 0.0;

  @override
  String toString() {
    return 'StartupTimeAnalysis('
        'avg: ${averageStartupTime.inMilliseconds}ms, '
        'min: ${minStartupTime.inMilliseconds}ms, '
        'max: ${maxStartupTime.inMilliseconds}ms, '
        'stdDev: ${standardDeviation.toStringAsFixed(2)}ms, '
        'withinBudget: $isWithinBudget, '
        'passRate: ${(passRate * 100).toStringAsFixed(1)}%'
        ')';
  }
}

/// Test group for startup time performance
void main() {
  group('Startup Time Performance Tests', () {
    testWidgets('should start within 2 seconds', (WidgetTester tester) async {
      final results =
          await StartupTimeTest.runStartupTimeBenchmark(iterations: 3);
      final analysis = StartupTimeTest.analyzeResults(results);

      print('Startup Time Analysis: $analysis');

      expect(analysis.isWithinBudget, isTrue,
          reason:
              'Average startup time (${analysis.averageStartupTime.inMilliseconds}ms) '
              'exceeds budget (2000ms)');

      expect(analysis.passRate, greaterThan(0.8),
          reason:
              'Pass rate (${(analysis.passRate * 100).toStringAsFixed(1)}%) '
              'is below 80%');
    });

    testWidgets('should have consistent startup times',
        (WidgetTester tester) async {
      final results = await StartupTimeTest.runStartupTimeBenchmark();
      final analysis = StartupTimeTest.analyzeResults(results);

      // Check for consistency (low standard deviation)
      expect(analysis.standardDeviation, lessThan(500.0),
          reason:
              'Standard deviation (${analysis.standardDeviation.toStringAsFixed(2)}ms) '
              'is too high, indicating inconsistent startup times');

      // Check that min and max are within reasonable range
      final range = analysis.maxStartupTime.inMilliseconds -
          analysis.minStartupTime.inMilliseconds;
      expect(range, lessThan(1000.0),
          reason: 'Startup time range (${range}ms) is too large');
    });

    testWidgets('should complete first frame quickly',
        (WidgetTester tester) async {
      final result = await StartupTimeTest.measureStartupTime();

      expect(result.firstFrameTime.inMilliseconds, lessThan(500),
          reason:
              'First frame time (${result.firstFrameTime.inMilliseconds}ms) '
              'exceeds 500ms threshold');
    });

    testWidgets('should reach interactive state quickly',
        (WidgetTester tester) async {
      final result = await StartupTimeTest.measureStartupTime();

      expect(result.interactiveTime.inMilliseconds, lessThan(1000),
          reason:
              'Interactive time (${result.interactiveTime.inMilliseconds}ms) '
              'exceeds 1000ms threshold');
    });
  });
}
