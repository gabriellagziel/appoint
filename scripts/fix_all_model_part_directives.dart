// ignore_for_file: avoid_print
import 'dart:io';

void main() async {
  print('Fixing all model part directives and moving generated files...');

  // Step 1: Update part directives in all model files to use default location
  await updatePartDirectivesToDefault();

  // Step 2: Run build runner to generate files in default location
  print('Running build runner to generate files...');
  final result = await Process.run(
    'flutter',
    ['pub', 'run', 'build_runner', 'build', '--delete-conflicting-outputs'],
  );
  if (result.exitCode != 0) {
    print('Build runner failed: ${result.stderr}');
    return;
  }

  // Step 3: Move generated files to centralized location
  await moveGeneratedFiles();

  // Step 4: Update part directives to point to centralized location
  await REDACTED_TOKEN();

  // Step 5: Update generated files' part of headers
  await updateGeneratedPartOfHeaders();

  print('All model part directives fixed!');
}

Future<void> updatePartDirectivesToDefault() async {
  print('Updating part directives to default location...');

  // Find all model files
  final modelFiles = await findModelFiles();

  for (final filePath in modelFiles) {
    final file = File(filePath);
    var content = await file.readAsString();
    var modified = false;

    // Update part directives to use default location
    content = content.replaceAllMapped(
      RegExp(r"part '\.\./generated/models/([^.]+)\.(freezed|g)\.dart';"),
      (match) {
        modified = true;
        return "part '${match.group(1)}.${match.group(2)}.dart';";
      },
    );

    if (modified) {
      await file.writeAsString(content);
      print('Updated: $filePath');
    }
  }
}

Future<void> moveGeneratedFiles() async {
  print('Moving generated files to centralized location...');

  // Create the target directory if it doesn't exist
  final targetDir = Directory('lib/generated/models');
  if (!await targetDir.exists()) {
    await targetDir.create(recursive: true);
  }

  // Find all generated files in model directories
  final result = await Process.run('find', [
    'lib/models',
    'lib/features/*/models',
    '-name',
    '*.g.dart',
    '-o',
    '-name',
    '*.freezed.dart',
  ]);
  final files = result.stdout.toString().trim().split('\n');

  for (final filePath in files) {
    if (filePath.isEmpty) continue;

    final file = File(filePath);
    if (!await file.exists()) continue;

    final fileName = filePath.split('/').last;
    final targetPath = 'lib/generated/models/$fileName';

    await file.copy(targetPath);
    await file.delete();
    print('Moved: $filePath -> $targetPath');
  }
}

Future<void> REDACTED_TOKEN() async {
  print('Updating part directives to centralized location...');

  final modelFiles = await findModelFiles();

  for (final filePath in modelFiles) {
    final file = File(filePath);
    var content = await file.readAsString();
    var modified = false;

    // Update part directives to use centralized location
    content = content.replaceAllMapped(
      RegExp(r"part '([^.]+)\.(freezed|g)\.dart';"),
      (match) {
        modified = true;
        return "part '../generated/models/${match.group(1)}.${match.group(2)}.dart';";
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

  final result =
      await Process.run('find', ['lib/generated/models', '-name', '*.dart']);
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
        return "part of 'package:appoint/models/$modelName.dart';";
      },
    );

    if (modified) {
      await file.writeAsString(content);
      print('Updated: $filePath');
    }
  }
}

Future<List<String>> findModelFiles() async {
  final result = await Process.run('find', [
    'lib/models',
    'lib/features/*/models',
    '-name',
    '*.dart',
    '-not',
    '-name',
    '*.g.dart',
    '-not',
    '-name',
    '*.freezed.dart',
  ]);
  return result.stdout
      .toString()
      .trim()
      .split('\n')
      .where((path) => path.isNotEmpty)
      .toList();
}
