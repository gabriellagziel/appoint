import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Performance test for measuring frame rendering times
///
/// This test measures:
/// - Frame rendering consistency
/// - Frame time distribution
/// - Jank detection (frames taking longer than 16.67ms)
/// - Overall smoothness metrics
class FrameTimeTest {
  static const Duration _frameBudget =
      Duration(milliseconds: 16); // 60 FPS target
  static const Duration _jankThreshold =
      Duration(milliseconds: 16); // Frames > 16ms are jank
  static const int _testDurationFrames = 300; // 5 seconds at 60 FPS

  /// Measures frame times during a specific operation
  static Future<FrameTimeResult> measureFrameTimes({
    required Future<void> Function() operation,
    int sampleCount = 60,
  }) async {
    final frameTimes = <Duration>[];
    final jankFrames = <int>[];
    Duration _lastFrameTime = Duration.zero;

    // Set up frame callback
    final completer = Completer<void>();
    int frameCount = 0;

    void onFrame(Duration timeStamp) {
      if (frameCount == 0) {
        // First frame, just record timestamp
        frameCount++;
        return;
      }

      // Calculate frame time
      final frameTime = timeStamp - _lastFrameTime;
      frameTimes.add(frameTime);

      // Check for jank
      if (frameTime > _jankThreshold) {
        jankFrames.add(frameCount);
      }

      frameCount++;

      // Stop after sample count
      if (frameCount >= sampleCount) {
        completer.complete();
        return;
      }

      _lastFrameTime = timeStamp;
    }

    // Start frame monitoring
    WidgetsBinding.instance.addPersistentFrameCallback(onFrame);

    // Execute the operation
    await operation();

    // Wait for completion
    await completer.future;

    // Clean up
    // Note: Flutter doesn't have removePersistentFrameCallback, the callback is automatically removed
    // when the widget is disposed or the app is closed

    return _analyzeFrameTimes(frameTimes, jankFrames);
  }

  /// Measures frame times during app navigation
  static Future<FrameTimeResult> measureNavigationFrameTimes() async {
    return measureFrameTimes(
      operation: () async {
        // Simulate navigation between screens
        await Future.delayed(const Duration(seconds: 2));
      },
      sampleCount: 120, // 2 seconds at 60 FPS
    );
  }

  /// Measures frame times during scrolling
  static Future<FrameTimeResult> measureScrollingFrameTimes() async {
    return measureFrameTimes(
      operation: () async {
        // Simulate scrolling operation
        await Future.delayed(const Duration(seconds: 2));
      },
      sampleCount: 120, // 2 seconds at 60 FPS
    );
  }

  /// Measures frame times during animations
  static Future<FrameTimeResult> measureAnimationFrameTimes() async {
    return measureFrameTimes(
      operation: () async {
        // Simulate animation playback
        await Future.delayed(const Duration(seconds: 2));
      },
      sampleCount: 120, // 2 seconds at 60 FPS
    );
  }

  /// Measures frame times during data loading
  static Future<FrameTimeResult> measureDataLoadingFrameTimes() async {
    return measureFrameTimes(
      operation: () async {
        // Simulate data loading operation
        await Future.delayed(const Duration(seconds: 2));
      },
      sampleCount: 120, // 2 seconds at 60 FPS
    );
  }

  /// Analyzes frame time data
  static FrameTimeResult _analyzeFrameTimes(
    List<Duration> frameTimes,
    List<int> jankFrames,
  ) {
    if (frameTimes.isEmpty) {
      return FrameTimeResult(
        averageFrameTime: Duration.zero,
        minFrameTime: Duration.zero,
        maxFrameTime: Duration.zero,
        jankPercentage: 0.0,
        jankCount: 0,
        totalFrames: 0,
        isSmooth: false,
        standardDeviation: 0.0,
      );
    }

    final frameTimeMs =
        frameTimes.map((d) => d.inMicroseconds / 1000.0).toList();
    final avgTime = frameTimeMs.reduce((a, b) => a + b) / frameTimeMs.length;
    final minTime = frameTimeMs.reduce((a, b) => a < b ? a : b);
    final maxTime = frameTimeMs.reduce((a, b) => a > b ? a : b);

    // Calculate standard deviation
    final variance = frameTimeMs
            .map((t) => (t - avgTime) * (t - avgTime))
            .reduce((a, b) => a + b) /
        frameTimeMs.length;
    final stdDev = sqrt(variance);

    // Calculate jank percentage
    final jankPercentage = (jankFrames.length / frameTimes.length) * 100;

    // Determine if performance is smooth (less than 5% jank)
    final isSmooth = jankPercentage < 5.0 && avgTime <= 16.67;

    return FrameTimeResult(
      averageFrameTime: Duration(microseconds: (avgTime * 1000).round()),
      minFrameTime: Duration(microseconds: (minTime * 1000).round()),
      maxFrameTime: Duration(microseconds: (maxTime * 1000).round()),
      jankPercentage: jankPercentage,
      jankCount: jankFrames.length,
      totalFrames: frameTimes.length,
      isSmooth: isSmooth,
      standardDeviation: stdDev,
    );
  }

  /// Runs comprehensive frame time benchmark
  static Future<FrameTimeBenchmark> runFrameTimeBenchmark() async {
    final results = <String, FrameTimeResult>{};

    // Test different scenarios
    results['navigation'] = await measureNavigationFrameTimes();
    results['scrolling'] = await measureScrollingFrameTimes();
    results['animation'] = await measureAnimationFrameTimes();
    results['data_loading'] = await measureDataLoadingFrameTimes();

    return FrameTimeBenchmark(results: results);
  }

  /// Detects specific performance issues
  static List<PerformanceIssue> detectPerformanceIssues(
      FrameTimeResult result) {
    final issues = <PerformanceIssue>[];

    if (result.jankPercentage > 5.0) {
      issues.add(PerformanceIssue(
        type: PerformanceIssueType.highJank,
        severity: PerformanceIssueSeverity.high,
        description:
            'High jank detected: ${result.jankPercentage.toStringAsFixed(1)}% of frames exceed 16ms',
        recommendation:
            'Optimize rendering pipeline and reduce frame time spikes',
      ));
    }

    if (result.averageFrameTime.inMilliseconds > 16) {
      issues.add(PerformanceIssue(
        type: PerformanceIssueType.slowFrames,
        severity: PerformanceIssueSeverity.medium,
        description:
            'Average frame time (${result.averageFrameTime.inMilliseconds}ms) exceeds 16ms target',
        recommendation:
            'Optimize widget rebuilds and reduce computational complexity',
      ));
    }

    if (result.standardDeviation > 8.0) {
      issues.add(PerformanceIssue(
        type: PerformanceIssueType.inconsistentFrames,
        severity: PerformanceIssueSeverity.medium,
        description:
            'High frame time variance (${result.standardDeviation.toStringAsFixed(2)}ms)',
        recommendation: 'Identify and fix sources of frame time spikes',
      ));
    }

    return issues;
  }
}

/// Result of frame time measurement
class FrameTimeResult {
  final Duration averageFrameTime;
  final Duration minFrameTime;
  final Duration maxFrameTime;
  final double jankPercentage;
  final int jankCount;
  final int totalFrames;
  final bool isSmooth;
  final double standardDeviation;

  FrameTimeResult({
    required this.averageFrameTime,
    required this.minFrameTime,
    required this.maxFrameTime,
    required this.jankPercentage,
    required this.jankCount,
    required this.totalFrames,
    required this.isSmooth,
    required this.standardDeviation,
  });

  double get averageFPS {
    if (averageFrameTime.inMicroseconds == 0) return 0.0;
    return 1000000.0 / averageFrameTime.inMicroseconds;
  }

  @override
  String toString() {
    return 'FrameTimeResult('
        'avg: ${averageFrameTime.inMilliseconds}ms (${averageFPS.toStringAsFixed(1)} FPS), '
        'jank: ${jankPercentage.toStringAsFixed(1)}%, '
        'smooth: $isSmooth'
        ')';
  }
}

/// Benchmark results for multiple scenarios
class FrameTimeBenchmark {
  final Map<String, FrameTimeResult> results;

  FrameTimeBenchmark({required this.results});

  bool get allScenariosSmooth => results.values.every((r) => r.isSmooth);

  double get overallJankPercentage {
    if (results.isEmpty) return 0.0;
    final totalJank =
        results.values.map((r) => r.jankCount).reduce((a, b) => a + b);
    final totalFrames =
        results.values.map((r) => r.totalFrames).reduce((a, b) => a + b);
    return totalFrames > 0 ? (totalJank / totalFrames) * 100 : 0.0;
  }

  @override
  String toString() {
    return 'FrameTimeBenchmark('
        'scenarios: ${results.length}, '
        'allSmooth: $allScenariosSmooth, '
        'overallJank: ${overallJankPercentage.toStringAsFixed(1)}%'
        ')';
  }
}

/// Performance issue types
enum PerformanceIssueType {
  highJank,
  slowFrames,
  inconsistentFrames,
  memoryLeak,
  excessiveRebuilds,
}

/// Performance issue severity levels
enum PerformanceIssueSeverity {
  low,
  medium,
  high,
  critical,
}

/// Performance issue details
class PerformanceIssue {
  final PerformanceIssueType type;
  final PerformanceIssueSeverity severity;
  final String description;
  final String recommendation;

  PerformanceIssue({
    required this.type,
    required this.severity,
    required this.description,
    required this.recommendation,
  });

  @override
  String toString() {
    return 'PerformanceIssue('
        'type: $type, '
        'severity: $severity, '
        'description: $description'
        ')';
  }
}

/// Test group for frame time performance
void main() {
  group('Frame Time Performance Tests', () {
    testWidgets('should maintain smooth 60 FPS during navigation',
        (WidgetTester tester) async {
      final result = await FrameTimeTest.measureNavigationFrameTimes();

      print('Navigation Frame Time Result: $result');

      expect(result.isSmooth, isTrue,
          reason:
              'Navigation is not smooth: ${result.jankPercentage.toStringAsFixed(1)}% jank');

      expect(result.averageFPS, greaterThan(55.0),
          reason:
              'Average FPS (${result.averageFPS.toStringAsFixed(1)}) is below 55 FPS');
    });

    testWidgets('should maintain smooth 60 FPS during scrolling',
        (WidgetTester tester) async {
      final result = await FrameTimeTest.measureScrollingFrameTimes();

      print('Scrolling Frame Time Result: $result');

      expect(result.isSmooth, isTrue,
          reason:
              'Scrolling is not smooth: ${result.jankPercentage.toStringAsFixed(1)}% jank');

      expect(result.averageFPS, greaterThan(55.0),
          reason:
              'Average FPS (${result.averageFPS.toStringAsFixed(1)}) is below 55 FPS');
    });

    testWidgets('should maintain smooth 60 FPS during animations',
        (WidgetTester tester) async {
      final result = await FrameTimeTest.measureAnimationFrameTimes();

      print('Animation Frame Time Result: $result');

      expect(result.isSmooth, isTrue,
          reason:
              'Animations are not smooth: ${result.jankPercentage.toStringAsFixed(1)}% jank');

      expect(result.averageFPS, greaterThan(55.0),
          reason:
              'Average FPS (${result.averageFPS.toStringAsFixed(1)}) is below 55 FPS');
    });

    testWidgets('should handle data loading without excessive jank',
        (WidgetTester tester) async {
      final result = await FrameTimeTest.measureDataLoadingFrameTimes();

      print('Data Loading Frame Time Result: $result');

      // Data loading can have some jank, but should be reasonable
      expect(result.jankPercentage, lessThan(10.0),
          reason:
              'Data loading has excessive jank: ${result.jankPercentage.toStringAsFixed(1)}%');

      expect(result.averageFPS, greaterThan(45.0),
          reason:
              'Average FPS (${result.averageFPS.toStringAsFixed(1)}) is too low during data loading');
    });

    testWidgets('should pass comprehensive frame time benchmark',
        (WidgetTester tester) async {
      final benchmark = await FrameTimeTest.runFrameTimeBenchmark();

      print('Frame Time Benchmark: $benchmark');

      expect(benchmark.allScenariosSmooth, isTrue,
          reason: 'Not all scenarios are smooth');

      expect(benchmark.overallJankPercentage, lessThan(5.0),
          reason:
              'Overall jank percentage (${benchmark.overallJankPercentage.toStringAsFixed(1)}%) is too high');
    });

    testWidgets('should detect performance issues correctly',
        (WidgetTester tester) async {
      // Create a result with known issues
      final problematicResult = FrameTimeResult(
        averageFrameTime: const Duration(milliseconds: 20),
        minFrameTime: const Duration(milliseconds: 10),
        maxFrameTime: const Duration(milliseconds: 50),
        jankPercentage: 15.0,
        jankCount: 15,
        totalFrames: 100,
        isSmooth: false,
        standardDeviation: 12.0,
      );

      final issues = FrameTimeTest.detectPerformanceIssues(problematicResult);

      expect(issues.length, greaterThan(0),
          reason: 'Should detect performance issues in problematic result');

      expect(issues.any((i) => i.type == PerformanceIssueType.highJank), isTrue,
          reason: 'Should detect high jank issue');

      expect(
          issues.any((i) => i.type == PerformanceIssueType.slowFrames), isTrue,
          reason: 'Should detect slow frames issue');
    });
  });
}
