// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Script to generate allowed Google Sign-In origins based on available
/// localization files.
void main() {
  final l10nDir = Directory('l10n').existsSync()
      ? Directory('l10n')
      : Directory('lib/l10n');

  const defaultOrigin = 'https://app-oint-core.firebaseapp.com';
  final origins = <String>{defaultOrigin};

  if (l10nDir.existsSync()) {
    for (final entity in l10nDir.listSync()) {
      if (entity is File && entity.path.endsWith('.arb')) {
        final name = entity.uri.pathSegments.last;
        final match = RegExp(r'app_([^.]+)\.arb$').firstMatch(name);
        if (match != null) {
          final locale = match.group(1)!;
          final country =
              (locale.contains('_') ? locale.split('_').last : locale)
                  .toLowerCase();
          origins.add('https://app-oint-core.$country.firebaseapp.com');
        }
      }
    }
  }

  final sorted = origins.toList()..sort();

  final jsonFile = File('config/google_origins.json')
    ..createSync(recursive: true);
  jsonFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({'origins': sorted}),
  );

  final dartFile = File('lib/config/region_origins.dart')
    ..createSync(recursive: true);
  final buffer = StringBuffer('const List<String> allowedOrigins = [\n');
  for (final origin in sorted) {
    buffer.writeln("  '$origin',");
  }
  buffer.writeln('];');
  dartFile.writeAsStringSync(buffer.toString());

  stdout.writeln('Generated ${sorted.length} origins.');
}
