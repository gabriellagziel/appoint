// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('Fixing part directives to point to generated/ directory...');

  // Find all Dart files that have part directives
  final result = await Process.run('find', [
    'lib',
    '-name',
    '*.dart',
    '-exec',
    'grep',
    '-l',
    r"part '.*\.g\.dart'",
    '{}',
    ';',
  ]);
  final files = result.stdout.toString().trim().split('\n');

  print('Found ${files.length} files with part directives');

  for (final filePath in files) {
    if (filePath.isEmpty) continue;

    final file = File(filePath);
    if (!await file.exists()) continue;

    var content = await file.readAsString();
    var modified = false;

    // Update part directives for .g.dart files
    content = content.replaceAllMapped(
      RegExp(r"part '([^']*\.g\.dart)';"),
      (match) {
        final fileName = match.group(1)!;
        modified = true;
        return "part 'generated/$fileName';";
      },
    );

    // Update part directives for .freezed.dart files
    content = content.replaceAllMapped(
      RegExp(r"part '([^']*\.freezed\.dart)';"),
      (match) {
        final fileName = match.group(1)!;
        modified = true;
        return "part 'generated/$fileName';";
      },
    );

    if (modified) {
      await file.writeAsString(content);
      print('Updated: $filePath');
    }
  }

  print('Part directives updated successfully!');
}
