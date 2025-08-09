#!/usr/bin/env dart

import 'dart:io';

/// Coverage gap finder for the App-Oint Personal User App
///
/// Analyzes coverage/lcov.info and identifies files with <85% coverage,
/// providing detailed information about missing lines and generating test stubs.
void main() async {
  const coverageThreshold = 85.0;
  const lcovFile = 'coverage/lcov.info';

  if (!File(lcovFile).existsSync()) {
    print('❌ Coverage file not found: $lcovFile');
    print('Run: flutter test --coverage');
    exit(1);
  }

  final coverage = await parseCoverage(lcovFile);
  final gaps = findCoverageGaps(coverage, coverageThreshold);

  if (gaps.isEmpty) {
    print('✅ All lib/ files meet coverage threshold ($coverageThreshold%)');
    exit(0);
  }

  print('📊 Coverage Gap Analysis');
  print('=' * 50);
  print('Files below $coverageThreshold% coverage:');
  print('');

  // Sort by coverage percentage (lowest first)
  gaps.sort((a, b) => a.coverage.compareTo(b.coverage));

  for (final gap in gaps) {
    printGapDetails(gap);
  }

  // Generate test stubs
  await generateTestStubs(gaps);

  // Save report
  await saveGapReport(gaps);

  print('');
  print('📁 Generated:');
  print('  • coverage/gaps.txt - Detailed gap report');
  print('  • Test stubs for files below threshold');
  print('');
  print('💡 Next steps:');
  print('  • Review generated test stubs');
  print('  • Add missing test cases');
  print('  • Re-run: flutter test --coverage');
}

class CoverageGap {
  final String file;
  final double coverage;
  final int totalLines;
  final int coveredLines;
  final List<int> missingLines;

  CoverageGap({
    required this.file,
    required this.coverage,
    required this.totalLines,
    required this.coveredLines,
    required this.missingLines,
  });
}

class FileCoverage {
  final String file;
  final int totalLines;
  final int coveredLines;
  final Set<int> coveredLineNumbers;

  FileCoverage({
    required this.file,
    required this.totalLines,
    required this.coveredLines,
    required this.coveredLineNumbers,
  });

  double get coverage =>
      totalLines > 0 ? (coveredLines / totalLines) * 100 : 0.0;
}

Future<Map<String, FileCoverage>> parseCoverage(String lcovFile) async {
  final lines = await File(lcovFile).readAsLines();
  final coverage = <String, FileCoverage>{};

  String? currentFile;
  int totalLines = 0;
  int coveredLines = 0;
  final coveredLineNumbers = <int>{};

  for (final line in lines) {
    if (line.startsWith('SF:')) {
      // Save previous file if exists
      if (currentFile != null && currentFile.startsWith('lib/')) {
        coverage[currentFile] = FileCoverage(
          file: currentFile,
          totalLines: totalLines,
          coveredLines: coveredLines,
          coveredLineNumbers: coveredLineNumbers,
        );
      }

      // Start new file
      currentFile = line.substring(3);
      totalLines = 0;
      coveredLines = 0;
      coveredLineNumbers.clear();
    } else if (line.startsWith('LF:') && currentFile != null) {
      totalLines = int.parse(line.substring(3));
    } else if (line.startsWith('LH:') && currentFile != null) {
      coveredLines = int.parse(line.substring(3));
    } else if (line.startsWith('DA:') && currentFile != null) {
      final parts = line.substring(3).split(',');
      final lineNumber = int.parse(parts[0]);
      final hitCount = int.parse(parts[1]);

      if (hitCount > 0) {
        coveredLineNumbers.add(lineNumber);
      }
    }
  }

  // Save last file
  if (currentFile != null && currentFile.startsWith('lib/')) {
    coverage[currentFile] = FileCoverage(
      file: currentFile,
      totalLines: totalLines,
      coveredLines: coveredLines,
      coveredLineNumbers: coveredLineNumbers,
    );
  }

  return coverage;
}

List<CoverageGap> findCoverageGaps(
    Map<String, FileCoverage> coverage, double threshold) {
  final gaps = <CoverageGap>[];

  for (final file in coverage.keys) {
    final fileCoverage = coverage[file]!;

    if (fileCoverage.coverage < threshold) {
      final missingLines = <int>[];
      for (int i = 1; i <= fileCoverage.totalLines; i++) {
        if (!fileCoverage.coveredLineNumbers.contains(i)) {
          missingLines.add(i);
        }
      }

      gaps.add(CoverageGap(
        file: file,
        coverage: fileCoverage.coverage,
        totalLines: fileCoverage.totalLines,
        coveredLines: fileCoverage.coveredLines,
        missingLines: missingLines,
      ));
    }
  }

  return gaps;
}

void printGapDetails(CoverageGap gap) {
  final coverageColor = gap.coverage < 50
      ? '🔴'
      : gap.coverage < 75
          ? '🟡'
          : '🟠';

  print('$coverageColor ${gap.file}');
  print(
      '   Coverage: ${gap.coverage.toStringAsFixed(1)}% (${gap.coveredLines}/${gap.totalLines} lines)');

  if (gap.missingLines.isNotEmpty) {
    final missingRanges = _groupConsecutiveLines(gap.missingLines);
    final rangesText = missingRanges.map((range) {
      if (range.length == 1) {
        return range.first.toString();
      } else {
        return '${range.first}-${range.last}';
      }
    }).join(', ');

    print('   Missing lines: $rangesText');
  }
  print('');
}

List<List<int>> _groupConsecutiveLines(List<int> lines) {
  if (lines.isEmpty) return [];

  final sorted = lines.toList()..sort();
  final groups = <List<int>>[];
  var currentGroup = <int>[sorted.first];

  for (int i = 1; i < sorted.length; i++) {
    if (sorted[i] == sorted[i - 1] + 1) {
      currentGroup.add(sorted[i]);
    } else {
      groups.add(currentGroup);
      currentGroup = [sorted[i]];
    }
  }

  groups.add(currentGroup);
  return groups;
}

Future<void> generateTestStubs(List<CoverageGap> gaps) async {
  for (final gap in gaps) {
    await generateTestStub(gap);
  }
}

Future<void> generateTestStub(CoverageGap gap) async {
  final testPath = _getTestPath(gap.file);
  if (testPath == null) return;

  final testDir = Directory(testPath).parent;
  if (!testDir.existsSync()) {
    testDir.createSync(recursive: true);
  }

  if (File(testPath).existsSync()) {
    print('⚠️  Test file already exists: $testPath');
    return;
  }

  final testContent = _generateTestContent(gap);
  await File(testPath).writeAsString(testContent);

  print('📝 Generated test stub: $testPath');
}

String? _getTestPath(String libFile) {
  // Map lib/ paths to test/ paths
  if (libFile.startsWith('lib/features/')) {
    final featurePath = libFile.substring(4); // Remove 'lib/'
    return 'test/$featurePath';
  } else if (libFile.startsWith('lib/services/')) {
    final servicePath = libFile.substring(4); // Remove 'lib/'
    return 'test/$servicePath';
  } else if (libFile.startsWith('lib/controllers/')) {
    final controllerPath = libFile.substring(4); // Remove 'lib/'
    return 'test/$controllerPath';
  } else if (libFile.startsWith('lib/widgets/')) {
    final widgetPath = libFile.substring(4); // Remove 'lib/'
    return 'test/$widgetPath';
  } else if (libFile.startsWith('lib/screens/')) {
    final screenPath = libFile.substring(4); // Remove 'lib/'
    return 'test/$screenPath';
  }

  return null;
}

String _generateTestContent(CoverageGap gap) {
  final fileName = gap.file.split('/').last.replaceAll('.dart', '');
  final className = _fileNameToClassName(fileName);

  if (gap.file.contains('controller')) {
    return _generateControllerTest(className, gap);
  } else if (gap.file.contains('service')) {
    return _generateServiceTest(className, gap);
  } else if (gap.file.contains('widget') || gap.file.contains('screen')) {
    return _generateWidgetTest(className, gap);
  } else {
    return _generateGenericTest(className, gap);
  }
}

String _fileNameToClassName(String fileName) {
  return fileName
      .split('_')
      .map((part) => part.substring(0, 1).toUpperCase() + part.substring(1))
      .join();
}

String _generateControllerTest(String className, CoverageGap gap) {
  return '''import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/test/test_utils/pump.dart';
import 'package:appoint/test/test_utils/fixtures.dart';

import 'package:appoint/lib/${gap.file.substring(4)}';

void main() {
  group('$className Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize correctly', () {
      // TODO: Add initialization test
      expect(true, isTrue);
    });

    test('should handle state changes', () {
      // TODO: Add state management tests
      expect(true, isTrue);
    });

    test('should validate input data', () {
      // TODO: Add validation tests
      expect(true, isTrue);
    });

    test('should handle errors gracefully', () {
      // TODO: Add error handling tests
      expect(true, isTrue);
    });

    // TODO: Add more specific tests based on missing coverage
    // Missing lines: ${gap.missingLines.join(', ')}
  });
}
''';
}

String _generateServiceTest(String className, CoverageGap gap) {
  return '''import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/test/test_utils/fakes.dart';
import 'package:appoint/test/test_utils/fixtures.dart';

import 'package:appoint/lib/${gap.file.substring(4)}';

void main() {
  group('$className Tests', () {
    late $className service;

    setUp(() {
      service = $className();
    });

    test('should initialize correctly', () {
      expect(service, isNotNull);
    });

    test('should handle basic operations', () {
      // TODO: Add basic operation tests
      expect(true, isTrue);
    });

    test('should handle network errors', () {
      // TODO: Add error handling tests
      expect(true, isTrue);
    });

    test('should validate input parameters', () {
      // TODO: Add validation tests
      expect(true, isTrue);
    });

    // TODO: Add more specific tests based on missing coverage
    // Missing lines: ${gap.missingLines.join(', ')}
  });
}
''';
}

String _generateWidgetTest(String className, CoverageGap gap) {
  return '''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/test/test_utils/pump.dart';
import 'package:appoint/test/test_utils/fixtures.dart';

import 'package:appoint/lib/${gap.file.substring(4)}';

void main() {
  group('$className Widget Tests', () {
    testWidgets('should render correctly', (tester) async {
      await tester.pumpWidgetWithProviders(
        $className(),
      );

      // TODO: Add widget rendering assertions
      expect(find.byType($className), findsOneWidget);
    });

    testWidgets('should handle user interactions', (tester) async {
      await tester.pumpWidgetWithProviders(
        $className(),
      );

      // TODO: Add interaction tests
      expect(true, isTrue);
    });

    testWidgets('should handle state changes', (tester) async {
      await tester.pumpWidgetWithProviders(
        $className(),
      );

      // TODO: Add state change tests
      expect(true, isTrue);
    });

    testWidgets('should handle errors gracefully', (tester) async {
      await tester.pumpWidgetWithProviders(
        $className(),
      );

      // TODO: Add error handling tests
      expect(true, isTrue);
    });

    // TODO: Add more specific tests based on missing coverage
    // Missing lines: ${gap.missingLines.join(', ')}
  });
}
''';
}

String _generateGenericTest(String className, CoverageGap gap) {
  return '''import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/test/test_utils/fixtures.dart';

import 'package:appoint/lib/${gap.file.substring(4)}';

void main() {
  group('$className Tests', () {
    test('should work correctly', () {
      // TODO: Add basic functionality tests
      expect(true, isTrue);
    });

    test('should handle edge cases', () {
      // TODO: Add edge case tests
      expect(true, isTrue);
    });

    test('should validate inputs', () {
      // TODO: Add input validation tests
      expect(true, isTrue);
    });

    // TODO: Add more specific tests based on missing coverage
    // Missing lines: ${gap.missingLines.join(', ')}
  });
}
''';
}

Future<void> saveGapReport(List<CoverageGap> gaps) async {
  final report = StringBuffer();

  report.writeln('Coverage Gap Report');
  report.writeln('Generated: ${DateTime.now()}');
  report.writeln('');

  for (final gap in gaps) {
    report.writeln('File: ${gap.file}');
    report.writeln('Coverage: ${gap.coverage.toStringAsFixed(1)}%');
    report.writeln('Lines: ${gap.coveredLines}/${gap.totalLines}');
    report.writeln('Missing lines: ${gap.missingLines.join(', ')}');
    report.writeln('');
  }

  await File('coverage/gaps.txt').writeAsString(report.toString());
}
