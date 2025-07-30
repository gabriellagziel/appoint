// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  final dartFiles = await _findDartFiles();

  for (final file in dartFiles) {
    await _processFile(file);
  }

  stdout.writeln('Debug code removal completed!');
}

Future<List<File>> _findDartFiles() async {
  final dir = Directory('.');
  final dartFiles = <File>[];

  await for (final entity in dir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('.dart') &&
        !entity.path.contains('/lib/l10n/') &&
        !entity.path.contains('.freezed.dart') &&
        !entity.path.contains('.mocks.dart') &&
        !entity.path.contains('/test/') &&
        !entity.path.contains('/integration_test/') &&
        !entity.path.contains('/scripts/')) {
      dartFiles.add(entity);
    }
  }

  return dartFiles;
}

Future<void> _processFile(final File file) async {
  final content = await file.readAsString();
  var modified = false;
  var newContent = content;

  // Remove print statements
  newContent = newContent.replaceAllMapped(
    RegExp(r'print\s*\(\s*[^)]*\)\s*;'),
    (final match) {
      modified = true;
      return '// Removed debug print: ${match.group(0)}';
    },
  );

  // Remove debugPrint statements
  newContent = newContent.replaceAllMapped(
    RegExp(r'debugPrint\s*\(\s*[^)]*\)\s*;'),
    (final match) {
      modified = true;
      return '// Removed debug print: ${match.group(0)}';
    },
  );

  // Remove TODO comments
  newContent = newContent.replaceAllMapped(
    RegExp(r'//\s*TODO[^\\n]*'),
    (final match) {
      modified = true;
      return '// TODO: Implement this feature';
    },
  );

  if (modified) {
    await file.writeAsString(newContent);
    stdout.writeln('Processed: ${file.path}');
  }
}
