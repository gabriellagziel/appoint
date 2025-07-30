import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

/// Change Analyzer for Intelligent Test Selection
///
/// Analyzes code changes and determines their impact on tests:
/// - Identifies which tests are affected by code changes
/// - Calculates risk scores for changes
/// - Determines test execution priority
/// - Maps code dependencies to test dependencies
class ChangeAnalyzer {
  static const String _testDependencyFile = 'ml/data/test_dependencies.json';
  static const String _codeCoverageFile = 'coverage/lcov.info';

  /// Analyzes the impact of code changes on tests
  static Future<ChangeImpact> analyzeChangeImpact({
    required String filePath,
    required List<String> changedLines,
    required Map<String, List<String>> testDependencies,
  }) async {
    try {
      // Load test dependencies
      final dependencies = await _loadTestDependencies();

      // Analyze code changes
      final changeAnalysis = await _analyzeCodeChanges(filePath, changedLines);

      // Identify impacted tests
      final impactedTests = _identifyImpactedTests(
        filePath,
        changedLines,
        dependencies,
        testDependencies,
      );

      // Calculate risk score
      final riskScore = _calculateRiskScore(changeAnalysis, impactedTests);

      // Calculate coverage impact
      final coverageImpact =
          await _calculateCoverageImpact(filePath, impactedTests);

      // Determine priority
      final priority =
          _determinePriority(riskScore, coverageImpact, impactedTests.length);

      return ChangeImpact(
        filePath: filePath,
        changedLines: changedLines,
        impactedTests: impactedTests,
        riskScore: riskScore,
        coverageImpact: coverageImpact,
        priority: priority,
        changeType: changeAnalysis.changeType,
        complexity: changeAnalysis.complexity,
        confidence: _calculateConfidence(changeAnalysis, impactedTests),
      );
    } catch (e) {
      throw ChangeAnalysisException('Failed to analyze change impact: $e');
    }
  }

  /// Analyzes multiple file changes
  static Future<List<ChangeImpact>> analyzeMultipleChanges({
    required Map<String, List<String>> fileChanges,
    required Map<String, List<String>> testDependencies,
  }) async {
    final impacts = <ChangeImpact>[];

    for (final entry in fileChanges.entries) {
      final filePath = entry.key;
      final changedLines = entry.value;

      final impact = await analyzeChangeImpact(
        filePath: filePath,
        changedLines: changedLines,
        testDependencies: testDependencies,
      );

      impacts.add(impact);
    }

    // Sort by priority (highest first)
    impacts.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return impacts;
  }

  /// Loads test dependencies from file
  static Future<Map<String, List<String>>> _loadTestDependencies() async {
    try {
      final file = File(_testDependencyFile);
      if (!await file.exists()) {
        return {};
      }

      final content = await file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;

      final dependencies = <String, List<String>>{};
      for (final entry in data.entries) {
        final testFile = entry.key;
        final deps = (entry.value as List<dynamic>).cast<String>();
        dependencies[testFile] = deps;
      }

      return dependencies;
    } catch (e) {
      print('Warning: Could not load test dependencies: $e');
      return {};
    }
  }

  /// Analyzes code changes in detail
  static Future<CodeChangeAnalysis> _analyzeCodeChanges(
    String filePath,
    List<String> changedLines,
  ) async {
    // Determine change type
    final changeType = _determineChangeType(filePath, changedLines);

    // Calculate complexity
    final complexity = _calculateComplexity(changedLines);

    // Analyze change patterns
    final patterns = _analyzeChangePatterns(changedLines);

    // Determine if changes are in critical areas
    final isCriticalArea = _isCriticalArea(filePath, changedLines);

    return CodeChangeAnalysis(
      changeType: changeType,
      complexity: complexity,
      patterns: patterns,
      isCriticalArea: isCriticalArea,
      linesChanged: changedLines.length,
    );
  }

  /// Determines the type of code change
  static ChangeType _determineChangeType(
      String filePath, List<String> changedLines) {
    final extension = path.extension(filePath).toLowerCase();

    // Analyze based on file type
    switch (extension) {
      case '.dart':
        return _analyzeDartChangeType(changedLines);
      case '.yaml':
      case '.yml':
        return ChangeType.configuration;
      case '.json':
        return ChangeType.data;
      case '.md':
        return ChangeType.documentation;
      default:
        return ChangeType.other;
    }
  }

  /// Analyzes Dart code change type
  static ChangeType _analyzeDartChangeType(List<String> changedLines) {
    bool hasMethodChanges = false;
    bool hasClassChanges = false;
    bool hasImportChanges = false;
    bool hasTestChanges = false;

    for (final line in changedLines) {
      if (line.contains('class ') || line.contains('abstract class ')) {
        hasClassChanges = true;
      }
      if (line.contains('(') && line.contains(')') && line.contains('{')) {
        hasMethodChanges = true;
      }
      if (line.contains('import ')) {
        hasImportChanges = true;
      }
      if (line.contains('test(') || line.contains('group(')) {
        hasTestChanges = true;
      }
    }

    if (hasTestChanges) return ChangeType.test;
    if (hasClassChanges) return ChangeType.structural;
    if (hasMethodChanges) return ChangeType.functional;
    if (hasImportChanges) return ChangeType.dependency;

    return ChangeType.logic;
  }

  /// Calculates complexity of changes
  static double _calculateComplexity(List<String> changedLines) {
    double complexity = 0.0;

    for (final line in changedLines) {
      // Count control structures
      if (line.contains('if ') || line.contains('else ')) complexity += 1;
      if (line.contains('for ') || line.contains('while ')) complexity += 2;
      if (line.contains('try ') || line.contains('catch ')) complexity += 1.5;
      if (line.contains('async ') || line.contains('await ')) complexity += 1;

      // Count method calls
      final methodCalls = RegExp(r'\w+\([^)]*\)').allMatches(line).length;
      complexity += methodCalls * 0.5;

      // Count operators
      final operators = RegExp(r'[+\-*/=<>!&|]').allMatches(line).length;
      complexity += operators * 0.2;
    }

    return complexity;
  }

  /// Analyzes change patterns
  static List<ChangePattern> _analyzeChangePatterns(List<String> changedLines) {
    final patterns = <ChangePattern>[];

    // Look for common patterns
    if (_hasPattern(changedLines, RegExp(r'null'))) {
      patterns.add(ChangePattern.nullHandling);
    }

    if (_hasPattern(changedLines, RegExp(r'throw '))) {
      patterns.add(ChangePattern.exceptionHandling);
    }

    if (_hasPattern(changedLines, RegExp(r'Future<'))) {
      patterns.add(ChangePattern.asyncChanges);
    }

    if (_hasPattern(changedLines, RegExp(r'Stream<'))) {
      patterns.add(ChangePattern.streamChanges);
    }

    if (_hasPattern(changedLines, RegExp(r'Map<|List<'))) {
      patterns.add(ChangePattern.dataStructureChanges);
    }

    return patterns;
  }

  /// Checks if changes are in critical areas
  static bool _isCriticalArea(String filePath, List<String> changedLines) {
    // Check if file is in critical directories
    final criticalDirs = [
      'lib/services/',
      'lib/providers/',
      'lib/models/',
      'lib/core/',
    ];

    for (final dir in criticalDirs) {
      if (filePath.contains(dir)) return true;
    }

    // Check if changes involve critical patterns
    for (final line in changedLines) {
      if (line.contains('main(') ||
          line.contains('runApp(') ||
          line.contains('MaterialApp(') ||
          line.contains('Firebase')) {
        return true;
      }
    }

    return false;
  }

  /// Identifies tests impacted by changes
  static List<String> _identifyImpactedTests(
    String filePath,
    List<String> changedLines,
    Map<String, List<String>> dependencies,
    Map<String, List<String>> testDependencies,
  ) {
    final impactedTests = <String>{};

    // Direct dependencies
    for (final entry in dependencies.entries) {
      final testFile = entry.key;
      final deps = entry.value;

      if (deps.contains(filePath)) {
        impactedTests.add(testFile);
      }
    }

    // Test dependencies
    for (final entry in testDependencies.entries) {
      final testFile = entry.key;
      final deps = entry.value;

      if (deps.contains(filePath)) {
        impactedTests.add(testFile);
      }
    }

    // Coverage-based impact
    final coverageImpacted = _getCoverageImpactedTests(filePath);
    impactedTests.addAll(coverageImpacted);

    return impactedTests.toList();
  }

  /// Gets tests that cover the changed file
  static List<String> _getCoverageImpactedTests(String filePath) {
    // This would typically parse coverage data
    // For now, we'll simulate based on file patterns
    final tests = <String>[];

    if (filePath.contains('/services/')) {
      tests.add(
          'test/services/${path.basename(filePath).replaceAll('.dart', '_test.dart')}');
    }

    if (filePath.contains('/models/')) {
      tests.add(
          'test/models/${path.basename(filePath).replaceAll('.dart', '_test.dart')}');
    }

    if (filePath.contains('/providers/')) {
      tests.add(
          'test/providers/${path.basename(filePath).replaceAll('.dart', '_test.dart')}');
    }

    return tests;
  }

  /// Calculates risk score for changes
  static double _calculateRiskScore(
    CodeChangeAnalysis analysis,
    List<String> impactedTests,
  ) {
    double riskScore = 0.0;

    // Base risk from change type
    switch (analysis.changeType) {
      case ChangeType.structural:
        riskScore += 0.8;
        break;
      case ChangeType.functional:
        riskScore += 0.6;
        break;
      case ChangeType.dependency:
        riskScore += 0.4;
        break;
      case ChangeType.logic:
        riskScore += 0.3;
        break;
      case ChangeType.test:
        riskScore += 0.1;
        break;
      case ChangeType.configuration:
        riskScore += 0.2;
        break;
      case ChangeType.data:
        riskScore += 0.3;
        break;
      case ChangeType.documentation:
        riskScore += 0.05;
        break;
      case ChangeType.other:
        riskScore += 0.2;
        break;
    }

    // Complexity factor
    riskScore += analysis.complexity * 0.1;

    // Critical area factor
    if (analysis.isCriticalArea) {
      riskScore += 0.5;
    }

    // Impact factor
    riskScore += (impactedTests.length * 0.05).clamp(0.0, 0.3);

    // Pattern factors
    for (final pattern in analysis.patterns) {
      switch (pattern) {
        case ChangePattern.nullHandling:
          riskScore += 0.2;
          break;
        case ChangePattern.exceptionHandling:
          riskScore += 0.3;
          break;
        case ChangePattern.asyncChanges:
          riskScore += 0.4;
          break;
        case ChangePattern.streamChanges:
          riskScore += 0.5;
          break;
        case ChangePattern.dataStructureChanges:
          riskScore += 0.3;
          break;
      }
    }

    return riskScore.clamp(0.0, 1.0);
  }

  /// Calculates coverage impact
  static Future<double> _calculateCoverageImpact(
    String filePath,
    List<String> impactedTests,
  ) async {
    try {
      final file = File(_codeCoverageFile);
      if (!await file.exists()) {
        return 0.0;
      }

      final content = await file.readAsString();
      final lines = content.split('\n');

      int totalLines = 0;
      int coveredLines = 0;

      for (final line in lines) {
        if (line.startsWith('LF:')) {
          totalLines = int.parse(line.substring(3));
        } else if (line.startsWith('LH:')) {
          coveredLines = int.parse(line.substring(3));
          break;
        }
      }

      if (totalLines > 0) {
        return coveredLines / totalLines;
      }

      return 0.0;
    } catch (e) {
      return 0.0;
    }
  }

  /// Determines test execution priority
  static TestPriority _determinePriority(
    double riskScore,
    double coverageImpact,
    int impactedTestCount,
  ) {
    if (riskScore > 0.8 || coverageImpact > 0.8) {
      return TestPriority.critical;
    }

    if (riskScore > 0.6 || coverageImpact > 0.6 || impactedTestCount > 10) {
      return TestPriority.high;
    }

    if (riskScore > 0.4 || coverageImpact > 0.4 || impactedTestCount > 5) {
      return TestPriority.medium;
    }

    return TestPriority.low;
  }

  /// Calculates confidence in the analysis
  static double _calculateConfidence(
    CodeChangeAnalysis analysis,
    List<String> impactedTests,
  ) {
    double confidence = 0.5; // Base confidence

    // Higher confidence for more specific change types
    if (analysis.changeType == ChangeType.test) confidence += 0.3;
    if (analysis.changeType == ChangeType.structural) confidence += 0.2;

    // Higher confidence for more impacted tests
    if (impactedTests.length > 0) confidence += 0.2;
    if (impactedTests.length > 5) confidence += 0.1;

    // Higher confidence for critical areas
    if (analysis.isCriticalArea) confidence += 0.1;

    return confidence.clamp(0.0, 1.0);
  }

  /// Helper method to check for patterns
  static bool _hasPattern(List<String> lines, RegExp pattern) {
    for (final line in lines) {
      if (pattern.hasMatch(line)) return true;
    }
    return false;
  }
}

/// Change impact analysis result
class ChangeImpact {
  final String filePath;
  final List<String> changedLines;
  final List<String> impactedTests;
  final double riskScore;
  final double coverageImpact;
  final TestPriority priority;
  final ChangeType changeType;
  final double complexity;
  final double confidence;

  ChangeImpact({
    required this.filePath,
    required this.changedLines,
    required this.impactedTests,
    required this.riskScore,
    required this.coverageImpact,
    required this.priority,
    required this.changeType,
    required this.complexity,
    required this.confidence,
  });

  @override
  String toString() {
    return 'ChangeImpact('
        'file: $filePath, '
        'impactedTests: ${impactedTests.length}, '
        'riskScore: ${riskScore.toStringAsFixed(2)}, '
        'priority: $priority'
        ')';
  }
}

/// Code change analysis details
class CodeChangeAnalysis {
  final ChangeType changeType;
  final double complexity;
  final List<ChangePattern> patterns;
  final bool isCriticalArea;
  final int linesChanged;

  CodeChangeAnalysis({
    required this.changeType,
    required this.complexity,
    required this.patterns,
    required this.isCriticalArea,
    required this.linesChanged,
  });
}

/// Types of code changes
enum ChangeType {
  structural, // Class, interface, or type changes
  functional, // Method or function changes
  dependency, // Import or dependency changes
  logic, // Logic or algorithm changes
  test, // Test code changes
  configuration, // Configuration changes
  data, // Data structure changes
  documentation, // Documentation changes
  other, // Other changes
}

/// Change patterns
enum ChangePattern {
  nullHandling,
  exceptionHandling,
  asyncChanges,
  streamChanges,
  dataStructureChanges,
}

/// Test execution priority
enum TestPriority {
  critical, // Must run immediately
  high, // Run in high priority batch
  medium, // Run in normal batch
  low, // Run in low priority batch
}

/// Exception for change analysis errors
class ChangeAnalysisException implements Exception {
  final String message;

  ChangeAnalysisException(this.message);

  @override
  String toString() => 'ChangeAnalysisException: $message';
}
