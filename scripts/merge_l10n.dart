// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

void main() async {
  final l10nDir = Directory('lib/l10n');
  final enFile = File('${l10nDir.path}/app_en.arb');
  if (!await enFile.exists()) {
    stderr.writeln('English ARB not found');
    exit(1);
  }
  final enMap = jsonDecode(await enFile.readAsString()) as Map<String, dynamic>;
  const encoder = JsonEncoder.withIndent('  ');
  final missing = <String, List<String>>{};

  await for (final entity in l10nDir.list()) {
    if (entity is File &&
        entity.path.endsWith('.arb') &&
        entity.path != enFile.path) {
      final map =
          jsonDecode(await entity.readAsString()) as Map<String, dynamic>;
      var updated = false;
      final locale = entity.uri.pathSegments.last
          .replaceFirst('app_', '')
          .replaceFirst('.arb', '');
      final missingKeys = <String>[];

      for (final key in enMap.keys) {
        if (!map.containsKey(key)) {
          missingKeys.add(key);
          map[key] = enMap[key];
          updated = true;
          stdout.writeln('${entity.path}: added missing key $key');
        } else if (map[key].runtimeType != enMap[key].runtimeType) {
          stdout.writeln('${entity.path}: conflicting key $key');
        }
      }

      for (final key in map.keys) {
        if (!enMap.containsKey(key)) {
          stdout.writeln('${entity.path}: extra key $key');
        }
      }

      if (updated) {
        await entity.writeAsString(encoder.convert(map));
      }

      if (missingKeys.isNotEmpty) {
        missing[locale] = missingKeys;
      }
    }
  }

  final buffer = StringBuffer()
    ..writeln('const Map<String, List<String>> missingTranslations = {');
  missing.forEach((final locale, final keys) {
    final joined = keys.map((final k) => "'$k'").join(', ');
    buffer.writeln("  '$locale': [$joined],");
  });
  buffer.writeln('};');

  final outputFile = File('${l10nDir.path}/l10n_contribution.dart');
  await outputFile.writeAsString(buffer.toString());
  stdout.writeln('Generated ${outputFile.path}');
}
