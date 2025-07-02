#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

void main() async {
  stdout.writeln('🔍 Starting localization completion...');

  // Get all ARB files
  final arbDir = Directory('lib/l10n');
  final arbFiles = arbDir
      .listSync()
      .where((final file) => file.path.endsWith('.arb'))
      .cast<File>()
      .toList();

  if (arbFiles.isEmpty) {
    stdout.writeln('❌ No ARB files found in lib/l10n');
    return;
  }

  // Use English as the base
  final baseFile = arbFiles.firstWhere(
    (final file) => file.path.contains('app_en.arb'),
    orElse: () => arbFiles.first,
  );

  stdout.writeln('📖 Using ${baseFile.path} as base file');

  final baseContent =
      json.decode(await baseFile.readAsString()) as Map<String, dynamic>;
  final baseKeys =
      baseContent.keys.where((final key) => !key.startsWith('@')).toSet();

  stdout.writeln('📊 Found ${baseKeys.length} base keys');

  // Process each ARB file
  for (final file in arbFiles) {
    if (file.path == baseFile.path) continue;

    stdout.writeln('\n🔧 Processing ${file.path}...');

    final content =
        json.decode(await file.readAsString()) as Map<String, dynamic>;
    final existingKeys =
        content.keys.where((final key) => !key.startsWith('@')).toSet();

    final missingKeys = baseKeys.difference(existingKeys);
    final extraKeys = existingKeys.difference(baseKeys);

    if (missingKeys.isNotEmpty) {
      stdout.writeln('  ➕ Adding ${missingKeys.length} missing keys...');

      for (final key in missingKeys) {
        final baseValue = baseContent[key];
        if (baseValue is String) {
          // Add TODO placeholder for missing translation
          content[key] = 'TODO: $baseValue';
        } else {
          content[key] = baseValue;
        }
      }
    }

    if (extraKeys.isNotEmpty) {
      stdout
          .writeln('  ⚠️  Found ${extraKeys.length} extra keys (keeping them)');
    }

    // Sort keys for consistency
    final sortedContent = <String, dynamic>{};
    final sortedKeys = content.keys.toList()..sort();

    for (final key in sortedKeys) {
      sortedContent[key] = content[key];
    }

    // Write back to file
    const encoder = JsonEncoder.withIndent('  ');
    await file.writeAsString(encoder.convert(sortedContent));

    stdout.writeln('  ✅ Updated ${file.path}');
  }

  stdout.writeln('\n🎉 Localization completion finished!');
  stdout.writeln('\n📝 Next steps:');
  stdout.writeln('1. Review TODO placeholders in ARB files');
  stdout.writeln('2. Replace TODO placeholders with actual translations');
  stdout.writeln('3. Run flutter gen-l10n to regenerate localization files');
  stdout.writeln('4. Test the app with different locales');
}
