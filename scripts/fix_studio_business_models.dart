// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('Fixing studio_business model part directives...');

  // Step 1: Update part directives in studio_business model files
  await updatePartDirectives();

  // Step 2: Update generated files' part of headers
  await updateGeneratedPartOfHeaders();

  print('All studio_business model part directives fixed!');
}

Future<void> updatePartDirectives() async {
  print('Updating part directives in studio_business models...');

  final result = await Process.run('find', [
    'lib/features/studio_business/models',
    '-name',
    '*.dart',
    '-not',
    '-name',
    '*.g.dart',
    '-not',
    '-name',
    '*.freezed.dart',
  ]);
  final files = result.stdout.toString().trim().split('\n');

  for (final filePath in files) {
    if (filePath.isEmpty) continue;

    final file = File(filePath);
    if (!await file.exists()) continue;

    var content = await file.readAsString();
    var modified = false;

    // Update part directives to use correct path
    content = content.replaceAllMapped(
      RegExp(
        r"part '\.\./\.\./\.\./generated/models/([^.]+)\.(freezed|g)\.dart';",
      ),
      (match) {
        modified = true;
        return "part '../../../generated/features/studio_business/models/${match.group(1)}.${match.group(2)}.dart';";
      },
    );

    if (modified) {
      await file.writeAsString(content);
      print('Updated: $filePath');
    }
  }
}

Future<void> updateGeneratedPartOfHeaders() async {
  print('Updating generated files part of headers...');

  final result = await Process.run(
    'find',
    ['lib/generated/features/studio_business/models', '-name', '*.dart'],
  );
  final files = result.stdout.toString().trim().split('\n');

  for (final filePath in files) {
    if (filePath.isEmpty) continue;

    final file = File(filePath);
    if (!await file.exists()) continue;

    var content = await file.readAsString();
    var modified = false;

    // Extract the model name from the file path
    final fileName = filePath.split('/').last;
    final modelName = fileName.replaceAll(RegExp(r'\.(freezed|g)\.dart$'), '');

    // Update part of header to use package path
    content = content.replaceAllMapped(
      RegExp("part of '[^']*';"),
      (match) {
        modified = true;
        return "part of 'package:appoint/features/studio_business/models/$modelName.dart';";
      },
    );

    if (modified) {
      await file.writeAsString(content);
      print('Updated: $filePath');
    }
  }
}
