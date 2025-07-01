import 'dart:io';
import 'dart:convert';

void main() async {
  final arbFile = File('lib/l10n/app_en.arb');
  if (!arbFile.existsSync()) {
    stderr.writeln('lib/l10n/app_en.arb not found');
    exit(1);
  }
  final arbMap = jsonDecode(await arbFile.readAsString()) as Map<String, dynamic>;
  final keys = <String>{};

  await for (final entity in Directory('lib').list(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    final lines = await entity.readAsLines();
    for (final line in lines) {
      if (line.trimLeft().startsWith('//')) continue;
      final regex = RegExp(r'l10n\.([a-zA-Z0-9_]+)');
      for (final match in regex.allMatches(line)) {
        keys.add(match.group(1)!);
      }
    }
  }

  final missing = keys.where((final k) => !arbMap.containsKey(k) && k != 'localeName');
  if (missing.isNotEmpty) {
    stderr.writeln('Missing localization keys:');
    for (final k in missing) {
      stderr.writeln('  $k');
    }
    exit(1);
  } else {
    print('All localization getters defined.');
  }
}
