// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('Moving generated files to generated/ directory...');

  // Find all .g.dart and .freezed.dart files
  final generatedFiles = <File>[];

  await for (final entity in Directory('lib').list(recursive: true)) {
    if (entity is File &&
        (entity.path.endsWith('.g.dart') ||
            entity.path.endsWith('.freezed.dart'))) {
      generatedFiles.add(entity);
    }
  }

  print('Found ${generatedFiles.length} generated files');

  for (final file in generatedFiles) {
    final relativePath = file.path.replaceFirst('lib/', '');
    final newPath = 'lib/generated/$relativePath';

    // Create directory if it doesn't exist
    final newDir = Directory(newPath).parent;
    if (!await newDir.exists()) {
      await newDir.create(recursive: true);
    }

    // Move the file
    await file.copy(newPath);
    await file.delete();

    print('Moved ${file.path} to $newPath');
  }

  // Update part directives in source files
  await updatePartDirectives();

  print('Generated files moved successfully!');
}

Future<void> updatePartDirectives() async {
  // Find all Dart files that have part directives
  await for (final entity in Directory('lib').list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('.dart') &&
        !entity.path.contains('.g.dart') &&
        !entity.path.contains('.freezed.dart')) {
      final content = await entity.readAsString();

      // Check if file has part directives
      if (content.contains('part ') &&
          (content.contains('.g.dart') || content.contains('.freezed.dart'))) {
        var updatedContent = content;

        // Update part directives to point to generated/ directory
        updatedContent = updatedContent.replaceAllMapped(
          RegExp(r"part '([^']*\.(?:g|freezed)\.dart)';"),
          (match) {
            final fileName = match.group(1)!;
            return "part 'generated/$fileName';";
          },
        );

        if (updatedContent != content) {
          await entity.writeAsString(updatedContent);
          print('Updated part directives in ${entity.path}');
        }
      }
    }
  }
}
