import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

/// Coverage Dashboard
/// 
/// Provides comprehensive coverage analytics including:
/// - Overall coverage metrics
/// - Coverage by category (models, services, features)
/// - Coverage trends over time
/// - Coverage gaps and recommendations
/// - Quality metrics and thresholds
class CoverageDashboard {
  static const String _coverageDataFile = 'coverage/lcov.info';
  static const String _coverageHistoryFile = 'coverage/coverage_history.json';
  
  /// Generates a comprehensive coverage report
  static Future<CoverageReport> generateCoverageReport() async {
    final report = CoverageReport();
    
    try {
      // Parse coverage data
      final coverageData = await _parseCoverageData();
      if (coverageData != null) {
        report.coverageData = coverageData;
      }
      
      // Load coverage history
      final history = await _loadCoverageHistory();
      report.coverageHistory = history;
      
      // Calculate metrics
      report.metrics = _calculateMetrics(report.coverageData);
      
      // Analyze trends
      report.trends = _analyzeTrends(report.coverageHistory);
      
      // Identify gaps
      report.gaps = _identifyCoverageGaps(report.coverageData);
      
      // Generate recommendations
      report.recommendations = _generateRecommendations(report);
      
    } catch (e) {
      report.errors.add('Failed to generate coverage report: $e');
    }
    
    return report;
  }
  
  /// Parses LCOV coverage data
  static Future<CoverageData?> _parseCoverageData() async {
    try {
      final file = File(_coverageDataFile);
      if (!await file.exists()) {
        return null;
      }
      
      final content = await file.readAsString();
      final lines = content.split('\n');
      
      final files = <CoverageFile>[];
      CoverageFile? currentFile;
      
      for (final line in lines) {
        if (line.startsWith('SF:')) {
          // Start of file
          final filePath = line.substring(3);
          currentFile = CoverageFile(path: filePath);
          files.add(currentFile);
        } else if (line.startsWith('LF:') && currentFile != null) {
          // Lines found
          currentFile.linesFound = int.parse(line.substring(3));
        } else if (line.startsWith('LH:') && currentFile != null) {
          // Lines hit
          currentFile.linesHit = int.parse(line.substring(3));
        } else if (line.startsWith('DA:') && currentFile != null) {
          // Line data
          final parts = line.substring(3).split(',');
          if (parts.length == 2) {
            final lineNumber = int.parse(parts[0]);
            final hitCount = int.parse(parts[1]);
            currentFile.lineData[lineNumber] = hitCount;
          }
        }
      }
      
      return CoverageData(files: files);
    } catch (e) {
      print('Error parsing coverage data: $e');
      return null;
    }
  }
  
  /// Loads coverage history
  static Future<List<CoverageSnapshot>> _loadCoverageHistory() async {
    try {
      final file = File(_coverageHistoryFile);
      if (!await file.exists()) {
        return [];
      }
      
      final content = await file.readAsString();
      final data = json.decode(content) as List<dynamic>;
      
      return data.map((item) => CoverageSnapshot.fromJson(item)).toList();
    } catch (e) {
      print('Error loading coverage history: $e');
      return [];
    }
  }
  
  /// Calculates coverage metrics
  static CoverageMetrics _calculateMetrics(CoverageData? coverageData) {
    if (coverageData == null) {
      return CoverageMetrics();
    }
    
    int totalLines = 0;
    int coveredLines = 0;
    int uncoveredLines = 0;
    
    for (final file in coverageData.files) {
      totalLines += file.linesFound;
      coveredLines += file.linesHit;
      uncoveredLines += (file.linesFound - file.linesHit);
    }
    
    final overallCoverage = totalLines > 0 ? (coveredLines / totalLines) * 100 : 0.0;
    
    // Calculate coverage by category
    final categoryCoverage = _calculateCategoryCoverage(coverageData.files);
    
    // Calculate file-level coverage
    final fileCoverage = coverageData.files.map((file) {
      final coverage = file.linesFound > 0 ? (file.linesHit / file.linesFound) * 100 : 0.0;
      return FileCoverage(
        path: file.path,
        coverage: coverage,
        linesFound: file.linesFound,
        linesHit: file.linesHit,
      );
    }).toList();
    
    return CoverageMetrics(
      overallCoverage: overallCoverage,
      totalLines: totalLines,
      coveredLines: coveredLines,
      uncoveredLines: uncoveredLines,
      categoryCoverage: categoryCoverage,
      fileCoverage: fileCoverage,
    );
  }
  
  /// Calculates coverage by category
  static Map<String, double> _calculateCategoryCoverage(List<CoverageFile> files) {
    final categories = <String, List<CoverageFile>>{};
    
    for (final file in files) {
      final category = _getFileCategory(file.path);
      categories.putIfAbsent(category, () => []).add(file);
    }
    
    final categoryCoverage = <String, double>{};
    
    for (final entry in categories.entries) {
      final category = entry.key;
      final categoryFiles = entry.value;
      
      int totalLines = 0;
      int coveredLines = 0;
      
      for (final file in categoryFiles) {
        totalLines += file.linesFound;
        coveredLines += file.linesHit;
      }
      
      final coverage = totalLines > 0 ? (coveredLines / totalLines) * 100 : 0.0;
      categoryCoverage[category] = coverage;
    }
    
    return categoryCoverage;
  }
  
  /// Gets the category for a file path
  static String _getFileCategory(String path) {
    if (path.contains('/models/')) return 'Models';
    if (path.contains('/services/')) return 'Services';
    if (path.contains('/features/')) return 'Features';
    if (path.contains('/widgets/')) return 'Widgets';
    if (path.contains('/providers/')) return 'Providers';
    if (path.contains('/utils/')) return 'Utils';
    return 'Other';
  }
  
  /// Analyzes coverage trends
  static List<CoverageTrend> _analyzeTrends(List<CoverageSnapshot> history) {
    if (history.length < 2) {
      return [];
    }
    
    final trends = <CoverageTrend>[];
    
    // Sort by date
    history.sort((a, b) => a.date.compareTo(b.date));
    
    for (int i = 1; i < history.length; i++) {
      final previous = history[i - 1];
      final current = history[i];
      
      final change = current.coverage - previous.coverage;
      final changePercentage = previous.coverage > 0 ? (change / previous.coverage) * 100 : 0.0;
      
      trends.add(CoverageTrend(
        date: current.date,
        previousCoverage: previous.coverage,
        currentCoverage: current.coverage,
        change: change,
        changePercentage: changePercentage,
        trend: change > 0 ? TrendDirection.increasing : 
               change < 0 ? TrendDirection.decreasing : TrendDirection.stable,
      ));
    }
    
    return trends;
  }
  
  /// Identifies coverage gaps
  static List<CoverageGap> _identifyCoverageGaps(CoverageData? coverageData) {
    if (coverageData == null) {
      return [];
    }
    
    final gaps = <CoverageGap>[];
    
    for (final file in coverageData.files) {
      final uncoveredLines = <int>[];
      
      for (final entry in file.lineData.entries) {
        if (entry.value == 0) {
          uncoveredLines.add(entry.key);
        }
      }
      
      if (uncoveredLines.isNotEmpty) {
        gaps.add(CoverageGap(
          filePath: file.path,
          uncoveredLines: uncoveredLines,
          totalLines: file.linesFound,
          coverage: file.linesFound > 0 ? (file.linesHit / file.linesFound) * 100 : 0.0,
        ));
      }
    }
    
    // Sort by coverage (lowest first)
    gaps.sort((a, b) => a.coverage.compareTo(b.coverage));
    
    return gaps;
  }
  
  /// Generates coverage recommendations
  static List<CoverageRecommendation> _generateRecommendations(CoverageReport report) {
    final recommendations = <CoverageRecommendation>[];
    
    // Check overall coverage
    if (report.metrics.overallCoverage < 80) {
      recommendations.add(CoverageRecommendation(
        type: RecommendationType.lowCoverage,
        priority: RecommendationPriority.high,
        description: 'Overall coverage is below 80% target',
        action: 'Focus on increasing test coverage for uncovered areas',
        impact: 'Improves code quality and reduces bug risk',
      ));
    }
    
    // Check category coverage
    for (final entry in report.metrics.categoryCoverage.entries) {
      final category = entry.key;
      final coverage = entry.value;
      
      if (coverage < 70) {
        recommendations.add(CoverageRecommendation(
          type: RecommendationType.categoryCoverage,
          priority: RecommendationPriority.medium,
          description: '$category coverage is below 70%',
          action: 'Add tests for $category components',
          impact: 'Improves reliability of $category functionality',
        ));
      }
    }
    
    // Check for files with no coverage
    final uncoveredFiles = report.gaps.where((gap) => gap.coverage == 0).length;
    if (uncoveredFiles > 0) {
      recommendations.add(CoverageRecommendation(
        type: RecommendationType.uncoveredFiles,
        priority: RecommendationPriority.high,
        description: '$uncoveredFiles files have no test coverage',
        action: 'Add tests for uncovered files',
        impact: 'Ensures all code is tested and validated',
      ));
    }
    
    // Check for large coverage gaps
    final largeGaps = report.gaps.where((gap) => gap.uncoveredLines.length > 10).length;
    if (largeGaps > 0) {
      recommendations.add(CoverageRecommendation(
        type: RecommendationType.largeGaps,
        priority: RecommendationPriority.medium,
        description: '$largeGaps files have large coverage gaps',
        action: 'Focus on testing critical paths in these files',
        impact: 'Reduces risk of bugs in complex code areas',
      ));
    }
    
    // Check coverage trends
    if (report.trends.isNotEmpty) {
      final recentTrends = report.trends.take(5).toList();
      final decreasingTrends = recentTrends.where((t) => t.trend == TrendDirection.decreasing).length;
      
      if (decreasingTrends > 2) {
        recommendations.add(CoverageRecommendation(
          type: RecommendationType.decreasingTrend,
          priority: RecommendationPriority.high,
          description: 'Coverage has been decreasing recently',
          action: 'Review recent changes and ensure tests are maintained',
          impact: 'Prevents coverage regression and maintains quality',
        ));
      }
    }
    
    return recommendations;
  }
  
  /// Exports coverage report to JSON
  static Future<String> exportToJson(CoverageReport report) async {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'metrics': {
        'overallCoverage': report.metrics.overallCoverage,
        'totalLines': report.metrics.totalLines,
        'coveredLines': report.metrics.coveredLines,
        'uncoveredLines': report.metrics.uncoveredLines,
      },
      'categoryCoverage': report.metrics.categoryCoverage,
      'fileCoverage': report.metrics.fileCoverage.map((f) => {
        'path': f.path,
        'coverage': f.coverage,
        'linesFound': f.linesFound,
        'linesHit': f.linesHit,
      }).toList(),
      'gaps': report.gaps.map((g) => {
        'filePath': g.filePath,
        'uncoveredLines': g.uncoveredLines,
        'totalLines': g.totalLines,
        'coverage': g.coverage,
      }).toList(),
      'recommendations': report.recommendations.map((r) => {
        'type': r.type.toString(),
        'priority': r.priority.toString(),
        'description': r.description,
        'action': r.action,
        'impact': r.impact,
      }).toList(),
      'errors': report.errors,
    };
    
    return json.encode(data);
  }
  
  /// Exports coverage report to HTML
  static Future<String> exportToHtml(CoverageReport report) async {
    final html = '''
<!DOCTYPE html>
<html>
<head>
    <title>Coverage Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #f0f0f0; padding: 20px; border-radius: 5px; }
        .metric { display: inline-block; margin: 10px; padding: 10px; background: #e8f5e8; border-radius: 5px; }
        .category { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        .gap { margin: 10px 0; padding: 10px; background: #fff3cd; border-radius: 3px; }
        .recommendation { margin: 10px 0; padding: 10px; background: #d1ecf1; border-radius: 3px; }
        .high { border-left: 4px solid #dc3545; }
        .medium { border-left: 4px solid #ffc107; }
        .low { border-left: 4px solid #28a745; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Coverage Report</h1>
        <p>Generated on: ${DateTime.now().toString()}</p>
    </div>
    
    <div class="metric">
        <h3>Overall Coverage</h3>
        <h2>${report.metrics.overallCoverage.toStringAsFixed(1)}%</h2>
    </div>
    
    <div class="metric">
        <h3>Total Lines</h3>
        <h2>${report.metrics.totalLines}</h2>
    </div>
    
    <div class="metric">
        <h3>Covered Lines</h3>
        <h2>${report.metrics.coveredLines}</h2>
    </div>
    
    <div class="metric">
        <h3>Uncovered Lines</h3>
        <h2>${report.metrics.uncoveredLines}</h2>
    </div>
    
    <div class="category">
        <h2>Coverage by Category</h2>
        ${report.metrics.categoryCoverage.entries.map((e) => 
          '<p><strong>${e.key}:</strong> ${e.value.toStringAsFixed(1)}%</p>'
        ).join()}
    </div>
    
    <div class="category">
        <h2>Coverage Gaps</h2>
        ${report.gaps.take(10).map((g) => 
          '<div class="gap"><strong>${g.filePath}</strong>: ${g.coverage.toStringAsFixed(1)}% (${g.uncoveredLines.length} uncovered lines)</div>'
        ).join()}
    </div>
    
    <div class="category">
        <h2>Recommendations</h2>
        ${report.recommendations.map((r) => 
          '<div class="recommendation ${r.priority.toString().split('.').last.toLowerCase()}">
            <strong>${r.description}</strong><br>
            Action: ${r.action}<br>
            Impact: ${r.impact}
          </div>'
        ).join()}
    </div>
</body>
</html>
    ''';
    
    return html;
  }
}

/// Coverage data structure
class CoverageData {
  final List<CoverageFile> files;
  
  CoverageData({required this.files});
}

/// Coverage file information
class CoverageFile {
  final String path;
  int linesFound = 0;
  int linesHit = 0;
  final Map<int, int> lineData = {};
  
  CoverageFile({required this.path});
}

/// Coverage metrics
class CoverageMetrics {
  final double overallCoverage;
  final int totalLines;
  final int coveredLines;
  final int uncoveredLines;
  final Map<String, double> categoryCoverage;
  final List<FileCoverage> fileCoverage;
  
  CoverageMetrics({
    this.overallCoverage = 0.0,
    this.totalLines = 0,
    this.coveredLines = 0,
    this.uncoveredLines = 0,
    this.categoryCoverage = const {},
    this.fileCoverage = const [],
  });
}

/// File coverage information
class FileCoverage {
  final String path;
  final double coverage;
  final int linesFound;
  final int linesHit;
  
  FileCoverage({
    required this.path,
    required this.coverage,
    required this.linesFound,
    required this.linesHit,
  });
}

/// Coverage snapshot for history
class CoverageSnapshot {
  final DateTime date;
  final double coverage;
  final int totalLines;
  final int coveredLines;
  
  CoverageSnapshot({
    required this.date,
    required this.coverage,
    required this.totalLines,
    required this.coveredLines,
  });
  
  factory CoverageSnapshot.fromJson(Map<String, dynamic> json) {
    return CoverageSnapshot(
      date: DateTime.parse(json['date']),
      coverage: json['coverage'].toDouble(),
      totalLines: json['totalLines'],
      coveredLines: json['coveredLines'],
    );
  }
}

/// Coverage trend information
class CoverageTrend {
  final DateTime date;
  final double previousCoverage;
  final double currentCoverage;
  final double change;
  final double changePercentage;
  final TrendDirection trend;
  
  CoverageTrend({
    required this.date,
    required this.previousCoverage,
    required this.currentCoverage,
    required this.change,
    required this.changePercentage,
    required this.trend,
  });
}

/// Trend direction
enum TrendDirection {
  increasing,
  decreasing,
  stable,
}

/// Coverage gap information
class CoverageGap {
  final String filePath;
  final List<int> uncoveredLines;
  final int totalLines;
  final double coverage;
  
  CoverageGap({
    required this.filePath,
    required this.uncoveredLines,
    required this.totalLines,
    required this.coverage,
  });
}

/// Coverage recommendation
class CoverageRecommendation {
  final RecommendationType type;
  final RecommendationPriority priority;
  final String description;
  final String action;
  final String impact;
  
  CoverageRecommendation({
    required this.type,
    required this.priority,
    required this.description,
    required this.action,
    required this.impact,
  });
}

/// Recommendation types
enum RecommendationType {
  lowCoverage,
  categoryCoverage,
  uncoveredFiles,
  largeGaps,
  decreasingTrend,
}

/// Recommendation priority
enum RecommendationPriority {
  low,
  medium,
  high,
}

/// Coverage report
class CoverageReport {
  CoverageData? coverageData;
  List<CoverageSnapshot> coverageHistory = [];
  CoverageMetrics metrics = CoverageMetrics();
  List<CoverageTrend> trends = [];
  List<CoverageGap> gaps = [];
  List<CoverageRecommendation> recommendations = [];
  List<String> errors = [];
  
  bool get hasErrors => errors.isNotEmpty;
  
  @override
  String toString() {
    return 'CoverageReport('
        'overallCoverage: ${metrics.overallCoverage.toStringAsFixed(1)}%, '
        'gaps: ${gaps.length}, '
        'recommendations: ${recommendations.length}'
        ')';
  }
} 