import 'dart:io';
import 'dart:convert';

void main() async {
  final l10nDir = Directory('lib/l10n');
  final enFile = File('${l10nDir.path}/app_en.arb');
  if (!await enFile.exists()) {
    stderr.writeln('English ARB not found');
    exit(1);
  }
  final enMap = jsonDecode(await enFile.readAsString()) as Map<String, dynamic>;
  final encoder = const JsonEncoder.withIndent('  ');

  await for (final entity in l10nDir.list()) {
    if (entity is File && entity.path.endsWith('.arb') && entity.path != enFile.path) {
      final map = jsonDecode(await entity.readAsString()) as Map<String, dynamic>;
      bool updated = false;

      for (final key in enMap.keys) {
        if (!map.containsKey(key)) {
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
    }
  }
}
