// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() {
  print('Validating ARB files...');

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
  print('Base language file: ${baseFile.path}');
  print('Base keys count: ${baseKeys.length}');

  var hasErrors = false;

  for (final file in arbFiles) {
    if (file.path == baseFile.path) continue;

    final fileKeys = _extractKeys(file);
    final missingKeys = baseKeys.difference(fileKeys);

    if (missingKeys.isNotEmpty) {
      print('❌ ${file.path} is missing ${missingKeys.length} keys:');
      for (final key in missingKeys) {
        print('  - $key');
      }
      hasErrors = true;
    } else {
      print('✅ ${file.path} - all keys present');
    }
  }

  if (hasErrors) {
    print('\n❌ ARB validation failed');
    exit(1);
  } else {
    print('\n✅ All ARB files are valid');
  }
}

Set<String> _extractKeys(FileSystemEntity file) {
  final content = File(file.path).readAsStringSync();
  final Map<String, dynamic> json = jsonDecode(content);

  return json.keys.where((key) => !key.startsWith('@')).toSet();
}
