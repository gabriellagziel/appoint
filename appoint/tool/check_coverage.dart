import 'dart:io';

void main(List<String> args) async {
  const globalThreshold = 70.0;
  const changedFileThreshold = 85.0;

  print('Checking coverage thresholds...');

  // Read lcov.info file
  final lcovFile = File('coverage/lcov.info');
  if (!lcovFile.existsSync()) {
    print('❌ Coverage file not found. Run tests with coverage first.');
    exit(1);
  }

  final lcovContent = lcovFile.readAsStringSync();
  final lines = lcovContent.split('\n');

  double totalLines = 0;
  double coveredLines = 0;
  Map<String, double> fileCoverage = {};

  // Parse lcov.info
  String? currentFile;
  for (final line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
    } else if (line.startsWith('LF:') && currentFile != null) {
      final linesFound = int.parse(line.substring(3));
      totalLines += linesFound;

      final nextLine = lines[lines.indexOf(line) + 1];
      if (nextLine.startsWith('LH:')) {
        final linesHit = int.parse(nextLine.substring(3));
        coveredLines += linesHit;

        final coverage = linesFound > 0 ? (linesHit / linesFound) * 100 : 0.0;
        fileCoverage[currentFile] = coverage;
      }
    }
  }

  final globalCoverage =
      totalLines > 0 ? (coveredLines / totalLines) * 100 : 0.0;

  print('📊 Coverage Summary:');
  print('Global coverage: ${globalCoverage.toStringAsFixed(1)}%');
  print('Total lines: ${totalLines.toInt()}');
  print('Covered lines: ${coveredLines.toInt()}');

  // Check global threshold
  if (globalCoverage < globalThreshold) {
    print(
        '❌ Global coverage (${globalCoverage.toStringAsFixed(1)}%) is below threshold ($globalThreshold%)');
    exit(1);
  } else {
    print(
        '✅ Global coverage (${globalCoverage.toStringAsFixed(1)}%) meets threshold ($globalThreshold%)');
  }

  // Check changed files coverage
  final changedFiles = await getChangedFiles();
  if (changedFiles.isNotEmpty) {
    print('\n📁 Checking coverage for changed files:');

    for (final file in changedFiles) {
      final coverage = fileCoverage[file];
      if (coverage != null) {
        print('$file: ${coverage.toStringAsFixed(1)}%');

        if (coverage < changedFileThreshold) {
          print(
              '❌ File coverage (${coverage.toStringAsFixed(1)}%) is below threshold ($changedFileThreshold%)');
          exit(1);
        }
      } else {
        print('⚠️  No coverage data for $file');
      }
    }

    print(
        '✅ All changed files meet coverage threshold ($changedFileThreshold%)');
  }

  print('\n🎉 All coverage checks passed!');
}

Future<List<String>> getChangedFiles() async {
  try {
    final result = await Process.run('git', ['diff', '--name-only', 'main']);
    if (result.exitCode == 0) {
      final files = result.stdout.toString().trim().split('\n');
      return files
          .where((file) =>
              file.startsWith('lib/') &&
              file.endsWith('.dart') &&
              !file.contains('test/'))
          .toList();
    }
  } catch (e) {
    print('⚠️  Could not determine changed files: $e');
  }
  return [];
}
