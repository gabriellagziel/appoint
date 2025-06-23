import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/l10n');
  final defaultOrigin = 'https://app-oint-core.firebaseapp.com';
  final origins = <String>{defaultOrigin};

  if (l10nDir.existsSync()) {
    for (final entity in l10nDir.listSync()) {
      if (entity is File && entity.path.endsWith('.arb')) {
        final name = entity.uri.pathSegments.last;
        final match = RegExp(r'app_(.+)\.arb').firstMatch(name);
        if (match != null) {
          final locale = match.group(1)!;
          if (locale.contains('_')) {
            final country = locale.split('_').last.toLowerCase();
            origins.add('https://app-oint-core.$country.firebaseapp.com');
          }
        }
      }
    }
  }

  final sorted = origins.toList()..sort();

  final jsonFile = File('config/google_origins.json');
  jsonFile.createSync(recursive: true);
  jsonFile.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({'origins': sorted}),
  );

  final dartFile = File('lib/config/region_origins.dart');
  dartFile.createSync(recursive: true);
  final buffer = StringBuffer('const List<String> allowedOrigins = [\n');
  for (final origin in sorted) {
    buffer.writeln("  '$origin',");
  }
  buffer.writeln('];');
  dartFile.writeAsStringSync(buffer.toString());

  stdout.writeln('Generated origins for ${sorted.length} region(s).');
}
