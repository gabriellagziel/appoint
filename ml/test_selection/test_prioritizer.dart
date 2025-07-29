import 'dart:convert';
import 'dart:io';
import 'dart:math';

/// Test Prioritizer for Intelligent Test Selection
///
/// Uses ML and historical data to prioritize tests:
/// - Analyzes test execution history
/// - Considers change impact and risk
/// - Predicts test relevance and failure probability
/// - Optimizes test execution order for maximum efficiency
class TestPrioritizer {
  static const String _executionHistoryFile =
      'ml/data/test_execution_history.json';
  static const String _testFeaturesFile = 'ml/data/test_features.json';
  static const String _mlModelFile = 'ml/models/test_prioritization_model.json';

  late Map<String, TestExecutionHistory> _executionHistory;
  late Map<String, TestFeatures> _testFeatures;
  late TestPrioritizationModel _mlModel;

  /// Initializes the test prioritizer
  Future<void> initialize() async {
    await _loadExecutionHistory();
    await _loadTestFeatures();
    await _loadMLModel();
  }

  /// Prioritizes tests based on change impact and historical data
  Future<List<TestPriorityResult>> prioritizeTests({
    required List<String> allTests,
    required ChangeImpact changeImpact,
    required TestExecutionContext context,
  }) async {
    try {
      final prioritizedTests = <TestPriorityResult>[];

      for (final testName in allTests) {
        // Extract features for the test
        final features = await _extractTestFeatures(
          testName,
          changeImpact,
          context,
        );

        // Get ML prediction
        final prediction = await _predictTestPriority(features);

        // Calculate manual priority score
        final manualScore = _calculateManualPriority(
          testName,
          changeImpact,
          context,
        );

        // Combine ML and manual scores
        final combinedScore = _combineScores(prediction.score, manualScore);

        // Determine final priority
        final priority =
            _determineFinalPriority(combinedScore, prediction.confidence);

        prioritizedTests.add(TestPriorityResult(
          testName: testName,
          priority: priority,
          score: combinedScore,
          confidence: prediction.confidence,
          predictedFailureProbability: prediction.failureProbability,
          executionTime: prediction.executionTime,
          relevanceScore: prediction.relevanceScore,
          features: features,
        ));
      }

      // Sort by priority (highest first)
      prioritizedTests.sort((a, b) => b.score.compareTo(a.score));

      return prioritizedTests;
    } catch (e) {
      throw TestPrioritizationException('Failed to prioritize tests: $e');
    }
  }

  /// Selects optimal test subset based on time constraints
  Future<List<String>> selectOptimalTestSubset({
    required List<TestPriorityResult> prioritizedTests,
    required Duration timeConstraint,
    required double coverageTarget,
  }) async {
    final selectedTests = <String>[];
    Duration totalTime = Duration.zero;
    double totalCoverage = 0.0;

    for (final test in prioritizedTests) {
      // Check if adding this test would exceed time constraint
      final projectedTime = totalTime + test.executionTime;
      if (projectedTime > timeConstraint) {
        break;
      }

      // Check if we've reached coverage target
      if (totalCoverage >= coverageTarget) {
        break;
      }

      selectedTests.add(test.testName);
      totalTime = projectedTime;
      totalCoverage += test.relevanceScore;
    }

    return selectedTests;
  }

  /// Loads test execution history
  Future<void> _loadExecutionHistory() async {
    try {
      final file = File(_executionHistoryFile);
      if (!await file.exists()) {
        _executionHistory = {};
        return;
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;

      _executionHistory = {};
      for (final entry in data.entries) {
        final testName = entry.key;
        final historyData = entry.value as Map<String, dynamic>;

        _executionHistory[testName] =
            TestExecutionHistory.fromJson(historyData);
      }
    } catch (e) {
      print('Warning: Could not load execution history: $e');
      _executionHistory = {};
    }
  }

  /// Loads test features
  Future<void> _loadTestFeatures() async {
    try {
      final file = File(_testFeaturesFile);
      if (!await file.exists()) {
        _testFeatures = {};
        return;
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;

      _testFeatures = {};
      for (final entry in data.entries) {
        final testName = entry.key;
        final featuresData = entry.value as Map<String, dynamic>;

        _testFeatures[testName] = TestFeatures.fromJson(featuresData);
      }
    } catch (e) {
      print('Warning: Could not load test features: $e');
      _testFeatures = {};
    }
  }

  /// Loads ML model
  Future<void> _loadMLModel() async {
    try {
      final file = File(_mlModelFile);
      if (!await file.exists()) {
        _mlModel = TestPrioritizationModel.defaultModel();
        return;
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;

      _mlModel = TestPrioritizationModel.fromJson(data);
    } catch (e) {
      print('Warning: Could not load ML model: $e');
      _mlModel = TestPrioritizationModel.defaultModel();
    }
  }

  /// Extracts features for a test
  Future<TestFeatureVector> _extractTestFeatures(
    String testName,
    ChangeImpact changeImpact,
    TestExecutionContext context,
  ) async {
    final history = _executionHistory[testName];
    final features = _testFeatures[testName];

    // Historical features
    final failureRate = history?.failureRate ?? 0.0;
    final avgExecutionTime =
        history?.averageExecutionTime.inMilliseconds ?? 1000;
    final lastExecutionTime = history?.lastExecutionTime ??
        DateTime.now().subtract(const Duration(days: 30));
    final executionCount = history?.executionCount ?? 0;

    // Change impact features
    final isDirectlyImpacted = changeImpact.impactedTests.contains(testName);
    final riskScore = changeImpact.riskScore;
    final coverageImpact = changeImpact.coverageImpact;

    // Test complexity features
    final testComplexity = features?.complexity ?? 1.0;
    final testSize = features?.size ?? 100;
    final testDependencies = features?.dependencies.length ?? 0;

    // Context features
    final timeOfDay = context.executionTime.hour;
    final dayOfWeek = context.executionTime.weekday;
    final isWeekend =
        dayOfWeek == DateTime.saturday || dayOfWeek == DateTime.sunday;

    return TestFeatureVector(
      failureRate: failureRate,
      avgExecutionTime: avgExecutionTime,
      daysSinceLastExecution:
          DateTime.now().difference(lastExecutionTime).inDays,
      executionCount: executionCount,
      isDirectlyImpacted: isDirectlyImpacted ? 1.0 : 0.0,
      riskScore: riskScore,
      coverageImpact: coverageImpact,
      testComplexity: testComplexity,
      testSize: testSize,
      testDependencies: testDependencies,
      timeOfDay: timeOfDay,
      isWeekend: isWeekend ? 1.0 : 0.0,
      changeType: _encodeChangeType(changeImpact.changeType),
      priority: _encodePriority(changeImpact.priority),
    );
  }

  /// Predicts test priority using ML model
  Future<TestPrediction> _predictTestPriority(
      TestFeatureVector features) async {
    try {
      // Use ML model to make prediction
      final prediction = await _mlModel.predict(features);

      return TestPrediction(
        score: prediction.score,
        confidence: prediction.confidence,
        failureProbability: prediction.failureProbability,
        executionTime: Duration(milliseconds: prediction.executionTimeMs),
        relevanceScore: prediction.relevanceScore,
      );
    } catch (e) {
      // Fallback to manual prediction
      return _manualPrediction(features);
    }
  }

  /// Manual prediction fallback
  TestPrediction _manualPrediction(TestFeatureVector features) {
    double score = 0.0;

    // Base score from failure rate
    score += features.failureRate * 0.3;

    // Impact score
    score += features.isDirectlyImpacted * 0.4;
    score += features.riskScore * 0.2;
    score += features.coverageImpact * 0.2;

    // Recency score
    final recencyScore = 1.0 / (1.0 + features.daysSinceLastExecution / 7.0);
    score += recencyScore * 0.1;

    // Complexity score
    score += (features.testComplexity * 0.05).clamp(0.0, 0.1);

    return TestPrediction(
      score: score.clamp(0.0, 1.0),
      confidence: 0.6,
      failureProbability: features.failureRate,
      executionTime: Duration(milliseconds: features.avgExecutionTime),
      relevanceScore:
          features.isDirectlyImpacted * 0.8 + features.riskScore * 0.2,
    );
  }

  /// Calculates manual priority score
  double _calculateManualPriority(
    String testName,
    ChangeImpact changeImpact,
    TestExecutionContext context,
  ) {
    double score = 0.0;

    // Direct impact
    if (changeImpact.impactedTests.contains(testName)) {
      score += 0.8;
    }

    // Risk-based scoring
    score += changeImpact.riskScore * 0.6;

    // Coverage impact
    score += changeImpact.coverageImpact * 0.4;

    // Priority-based scoring
    switch (changeImpact.priority) {
      case TestPriority.critical:
        score += 0.9;
        break;
      case TestPriority.high:
        score += 0.7;
        break;
      case TestPriority.medium:
        score += 0.5;
        break;
      case TestPriority.low:
        score += 0.3;
        break;
    }

    return score.clamp(0.0, 1.0);
  }

  /// Combines ML and manual scores
  double _combineScores(double mlScore, double manualScore) {
    // Weight ML score more heavily if we have good data
    const mlWeight = 0.7;
    const manualWeight = 0.3;

    return (mlScore * mlWeight) + (manualScore * manualWeight);
  }

  /// Determines final priority
  TestPriority _determineFinalPriority(double score, double confidence) {
    if (score > 0.8) return TestPriority.critical;
    if (score > 0.6) return TestPriority.high;
    if (score > 0.4) return TestPriority.medium;
    return TestPriority.low;
  }

  /// Encodes change type as numeric value
  double _encodeChangeType(ChangeType changeType) {
    switch (changeType) {
      case ChangeType.structural:
        return 0.9;
      case ChangeType.functional:
        return 0.7;
      case ChangeType.dependency:
        return 0.5;
      case ChangeType.logic:
        return 0.6;
      case ChangeType.test:
        return 0.2;
      case ChangeType.configuration:
        return 0.3;
      case ChangeType.data:
        return 0.4;
      case ChangeType.documentation:
        return 0.1;
      case ChangeType.other:
        return 0.3;
    }
  }

  /// Encodes priority as numeric value
  double _encodePriority(TestPriority priority) {
    switch (priority) {
      case TestPriority.critical:
        return 0.9;
      case TestPriority.high:
        return 0.7;
      case TestPriority.medium:
        return 0.5;
      case TestPriority.low:
        return 0.3;
    }
  }

  /// Updates execution history with new results
  Future<void> updateExecutionHistory({
    required String testName,
    required bool passed,
    required Duration executionTime,
  }) async {
    final history = _executionHistory[testName] ?? TestExecutionHistory();

    history.addExecution(passed, executionTime);
    _executionHistory[testName] = history;

    // Save updated history
    await _saveExecutionHistory();
  }

  /// Saves execution history to file
  Future<void> _saveExecutionHistory() async {
    try {
      final data = <String, dynamic>{};
      for (final entry in _executionHistory.entries) {
        data[entry.key] = entry.value.toJson();
      }

      final file = File(_executionHistoryFile);
      await file.create(recursive: true);
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Warning: Could not save execution history: $e');
    }
  }
}

/// Test priority result
class TestPriorityResult {
  final String testName;
  final TestPriority priority;
  final double score;
  final double confidence;
  final double predictedFailureProbability;
  final Duration executionTime;
  final double relevanceScore;
  final TestFeatureVector features;

  TestPriorityResult({
    required this.testName,
    required this.priority,
    required this.score,
    required this.confidence,
    required this.predictedFailureProbability,
    required this.executionTime,
    required this.relevanceScore,
    required this.features,
  });

  @override
  String toString() {
    return 'TestPriorityResult('
        'test: $testName, '
        'priority: $priority, '
        'score: ${score.toStringAsFixed(2)}, '
        'confidence: ${confidence.toStringAsFixed(2)}'
        ')';
  }
}

/// Test execution history
class TestExecutionHistory {
  List<bool> results = [];
  List<Duration> executionTimes = [];
  DateTime? lastExecutionTime;

  TestExecutionHistory();

  void addExecution(bool passed, Duration executionTime) {
    results.add(passed);
    executionTimes.add(executionTime);
    lastExecutionTime = DateTime.now();
  }

  double get failureRate {
    if (results.isEmpty) return 0.0;
    final failures = results.where((r) => !r).length;
    return failures / results.length;
  }

  Duration get averageExecutionTime {
    if (executionTimes.isEmpty) return const Duration(milliseconds: 1000);
    final totalMs =
        executionTimes.fold<int>(0, (sum, time) => sum + time.inMilliseconds);
    return Duration(milliseconds: totalMs ~/ executionTimes.length);
  }

  int get executionCount => results.length;

  Map<String, dynamic> toJson() => {
        'results': results,
        'executionTimes': executionTimes.map((t) => t.inMilliseconds).toList(),
        'lastExecutionTime': lastExecutionTime?.toIso8601String(),
      };

  factory TestExecutionHistory.fromJson(Map<String, dynamic> json) {
    final history = TestExecutionHistory();
    history.results = (json['results'] as List<dynamic>).cast<bool>();
    history.executionTimes = (json['executionTimes'] as List<dynamic>)
        .map((ms) => Duration(milliseconds: ms as int))
        .toList();
    if (json['lastExecutionTime'] != null) {
      history.lastExecutionTime = DateTime.parse(json['lastExecutionTime']);
    }
    return history;
  }
}

/// Test features
class TestFeatures {
  final double complexity;
  final int size;
  final List<String> dependencies;

  TestFeatures({
    required this.complexity,
    required this.size,
    required this.dependencies,
  });

  Map<String, dynamic> toJson() => {
        'complexity': complexity,
        'size': size,
        'dependencies': dependencies,
      };

  factory TestFeatures.fromJson(Map<String, dynamic> json) {
    return TestFeatures(
      complexity: json['complexity']?.toDouble() ?? 1.0,
      size: json['size'] ?? 100,
      dependencies:
          (json['dependencies'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

/// Test feature vector for ML
class TestFeatureVector {
  final double failureRate;
  final int avgExecutionTime;
  final int daysSinceLastExecution;
  final int executionCount;
  final double isDirectlyImpacted;
  final double riskScore;
  final double coverageImpact;
  final double testComplexity;
  final int testSize;
  final int testDependencies;
  final int timeOfDay;
  final double isWeekend;
  final double changeType;
  final double priority;

  TestFeatureVector({
    required this.failureRate,
    required this.avgExecutionTime,
    required this.daysSinceLastExecution,
    required this.executionCount,
    required this.isDirectlyImpacted,
    required this.riskScore,
    required this.coverageImpact,
    required this.testComplexity,
    required this.testSize,
    required this.testDependencies,
    required this.timeOfDay,
    required this.isWeekend,
    required this.changeType,
    required this.priority,
  });

  List<double> toList() => [
        failureRate,
        avgExecutionTime.toDouble(),
        daysSinceLastExecution.toDouble(),
        executionCount.toDouble(),
        isDirectlyImpacted,
        riskScore,
        coverageImpact,
        testComplexity,
        testSize.toDouble(),
        testDependencies.toDouble(),
        timeOfDay.toDouble(),
        isWeekend,
        changeType,
        priority,
      ];
}

/// Test prediction from ML model
class TestPrediction {
  final double score;
  final double confidence;
  final double failureProbability;
  final Duration executionTime;
  final double relevanceScore;

  TestPrediction({
    required this.score,
    required this.confidence,
    required this.failureProbability,
    required this.executionTime,
    required this.relevanceScore,
  });
}

/// Test execution context
class TestExecutionContext {
  final DateTime executionTime;
  final String environment;
  final Map<String, dynamic> parameters;

  TestExecutionContext({
    required this.executionTime,
    required this.environment,
    this.parameters = const {},
  });
}

/// ML model for test prioritization
class TestPrioritizationModel {
  final String version;
  final DateTime trainedAt;
  final Map<String, dynamic> parameters;

  TestPrioritizationModel({
    required this.version,
    required this.trainedAt,
    required this.parameters,
  });

  Future<TestPrediction> predict(TestFeatureVector features) async {
    // Simulate ML prediction
    await Future.delayed(const Duration(milliseconds: 10));

    final featureList = features.toList();
    double score = 0.0;

    // Simple weighted sum (in real implementation, this would be a trained model)
    score += featureList[0] * 0.3; // failure rate
    score += featureList[4] * 0.4; // is directly impacted
    score += featureList[5] * 0.2; // risk score
    score += featureList[6] * 0.2; // coverage impact
    score += featureList[13] * 0.3; // priority

    return TestPrediction(
      score: score.clamp(0.0, 1.0),
      confidence: 0.8,
      failureProbability: featureList[0],
      executionTime: Duration(milliseconds: featureList[1].toInt()),
      relevanceScore: featureList[4] * 0.8 + featureList[5] * 0.2,
    );
  }

  Map<String, dynamic> toJson() => {
        'version': version,
        'trainedAt': trainedAt.toIso8601String(),
        'parameters': parameters,
      };

  factory TestPrioritizationModel.fromJson(Map<String, dynamic> json) {
    return TestPrioritizationModel(
      version: json['version'] ?? '1.0.0',
      trainedAt: DateTime.parse(json['trainedAt']),
      parameters: json['parameters'] ?? {},
    );
  }

  factory TestPrioritizationModel.defaultModel() {
    return TestPrioritizationModel(
      version: '1.0.0',
      trainedAt: DateTime.now(),
      parameters: {},
    );
  }
}

/// Exception for test prioritization errors
class TestPrioritizationException implements Exception {
  final String message;

  TestPrioritizationException(this.message);

  @override
  String toString() => 'TestPrioritizationException: $message';
}
