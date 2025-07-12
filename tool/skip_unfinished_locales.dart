import 'dart:io';
import 'package:path/path.dart' as p;

void main() {
  final srcDir = Directory('lib/l10n');
  final dstDir = Directory('build/l10n');
  if (!dstDir.existsSync()) dstDir.createSync(recursive: true);

  for (final file in srcDir.listSync().whereType<File>().where(
        (f) => f.path.endsWith('.arb'),
      )) {
    final contents = file.readAsStringSync();
    if (!contents.contains('"TODO"') && !contents.contains('(TRANSLATE)')) {
      file.copySync(p.join(dstDir.path, p.basename(file.path)));
    } else {
      stdout.writeln(
        '⚠️  Skipping unfinished locale: ${p.basename(file.path)}',
      );
    }
  }
}
