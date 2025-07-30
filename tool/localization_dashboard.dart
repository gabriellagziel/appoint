// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() async {
  print('Generating localization dashboard...');

  final arbDir = Directory('lib/l10n');
  if (!arbDir.existsSync()) {
    print('❌ lib/l10n directory not found');
    exit(1);
  }

  final arbFiles =
      arbDir.listSync().where((f) => f.path.endsWith('.arb')).toList();
  if (arbFiles.isEmpty) {
    print('❌ No ARB files found in lib/l10n');
    exit(1);
  }

  // Find the base language file (usually app_en.arb)
  final baseFile = arbFiles.firstWhere(
    (f) => f.path.contains('_en.arb'),
    orElse: () => arbFiles.first,
  );

  final baseKeys = _extractKeys(baseFile);
  final baseKeyCount = baseKeys.length;

  print('Base language file: ${baseFile.path}');
  print('Total keys: $baseKeyCount');

  final statusData = <Map<String, dynamic>>[];

  for (final file in arbFiles) {
    final fileName = file.path.split('/').last;
    final languageCode = fileName.replaceAll('.arb', '').replaceAll('app_', '');
    final fileKeys = _extractKeys(file);
    final missingKeys = baseKeys.difference(fileKeys);
    final translatedKeys = baseKeys.intersection(fileKeys);
    final completionRate =
        (translatedKeys.length / baseKeyCount * 100).toStringAsFixed(1);

    statusData.add({
      'language': languageCode,
      'file': fileName,
      'total_keys': baseKeyCount,
      'translated_keys': translatedKeys.length,
      'missing_keys': missingKeys.length,
      'completion_rate': double.parse(completionRate),
      'missing_keys_list': missingKeys.toList(),
    });

    print(
      '$languageCode: $completionRate% complete (${translatedKeys.length}/$baseKeyCount)',
    );
  }

  // Generate markdown report
  await _generateMarkdownReport(statusData, baseKeyCount);

  print('\n✅ Localization dashboard generated successfully!');
}

Set<String> _extractKeys(FileSystemEntity file) {
  final content = File(file.path).readAsStringSync();
  final Map<String, dynamic> json = jsonDecode(content);

  return json.keys.where((key) => !key.startsWith('@')).toSet();
}

Future<void> _generateMarkdownReport(
  List<Map<String, dynamic>> statusData,
  int totalKeys,
) async {
  final report = StringBuffer();

  report.writeln('# Translation Status Report');
  report.writeln();
  report.writeln('Generated on: ${DateTime.now().toIso8601String()}');
  report.writeln();
  report.writeln('## Summary');
  report.writeln();
  report.writeln('| Language | Completion | Translated | Missing |');
  report.writeln('|----------|------------|------------|---------|');

  for (final data in statusData) {
    final language = data['language'];
    final completion = data['completion_rate'].toStringAsFixed(1) + '%';
    final translated = data['translated_keys'];
    final missing = data['missing_keys'];

    report.writeln('| $language | $completion | $translated | $missing |');
  }

  report.writeln();
  report.writeln('## Detailed Status');
  report.writeln();

  for (final data in statusData) {
    final language = data['language'];
    final completion = data['completion_rate'].toStringAsFixed(1) + '%';
    final missingKeys = data['missing_keys_list'] as List<String>;

    report.writeln('### $language ($completion complete)');
    report.writeln();

    if (missingKeys.isNotEmpty) {
      report.writeln('**Missing keys:**');
      report.writeln();
      for (final key in missingKeys) {
        report.writeln('- `$key`');
      }
      report.writeln();
    } else {
      report.writeln('✅ All keys translated!');
      report.writeln();
    }
  }

  report.writeln('## Recommendations');
  report.writeln();

  final incompleteLanguages =
      statusData.where((d) => d['completion_rate'] < 100).toList();
  if (incompleteLanguages.isNotEmpty) {
    report.writeln('### Priority Languages to Complete');
    report.writeln();

    // Sort by completion rate (lowest first)
    incompleteLanguages
        .sort((a, b) => a['completion_rate'].compareTo(b['completion_rate']));

    for (final data in incompleteLanguages) {
      final language = data['language'];
      final completion = data['completion_rate'].toStringAsFixed(1) + '%';
      final missing = data['missing_keys'];

      report.writeln('- **$language** ($completion): $missing keys missing');
    }
  } else {
    report.writeln('🎉 All languages are 100% complete!');
  }

  // Write to file
  final reportFile = File('docs/TRANSLATION_STATUS.md');
  await reportFile.parent.create(recursive: true);
  await reportFile.writeAsString(report.toString());

  print('Report written to: ${reportFile.path}');
}
