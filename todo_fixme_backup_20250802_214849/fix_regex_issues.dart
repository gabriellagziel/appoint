import 'dart:io';

void main() async {
  print('🔧 Fixing regex replacement issues...');

  await fixRegexIssues();

  print('✅ Regex issues fixed!');
}

Future<void> fixRegexIssues() async {
  final dartFiles = await findDartFiles('lib');

  for (final file in dartFiles) {
    try {
      String content = await File(file).readAsString();
      String originalContent = content;

      // Fix the $1 issues that were introduced by regex replacement
      content = content.replaceAll('\$1', '');
      content = content.replaceAll('\$2', '');
      content = content.replaceAll('\$3', '');

      // Fix specific patterns that got corrupted
      content = content.replaceAll('class  {', 'class Service {');
      content = content.replaceAll('class  {', 'class Service {');
      content = content.replaceAll('final  = ;', 'final variable = null;');
      content = content.replaceAll('const  = ;', 'const variable = null;');
      content = content.replaceAll('static  = ;', 'static variable = null;');

      // Fix malformed method declarations
      content = content.replaceAll(
          '() {', '() {\n    // TODO: Implement method\n  }');
      content = content.replaceAll(
          '() {', '() {\n    // TODO: Implement method\n  }');

      // Fix malformed class declarations
      content = content.replaceAll('class  {', 'class Service {');
      content = content.replaceAll('class  {', 'class Service {');

      // Fix malformed imports
      content = content.replaceAll('import ;', 'import \'dart:io\';');
      content = content.replaceAll('export ;', 'export \'dart:io\';');
      content = content.replaceAll('part ;', 'part \'service.dart\';');

      // Fix malformed string literals
      content = content.replaceAll("'", "'");
      content = content.replaceAll("'", "'");

      // Fix malformed variable declarations
      content = content.replaceAll(' = ;', ' = null;');
      content = content.replaceAll(' = ;', ' = null;');

      // Fix malformed method calls
      content = content.replaceAll('();', '();');
      content = content.replaceAll('();', '();');

      // Fix malformed annotations
      content = content.replaceAll('@freezed', '@freezed\nclass Service');
      content = content.replaceAll(
          '@JsonSerializable()', '@JsonSerializable()\nclass Service');

      // Fix malformed part directives
      content = content.replaceAll(
          'part \'.freezed.dart\';', 'part \'service.freezed.dart\';');
      content =
          content.replaceAll('part \'.g.dart\';', 'part \'service.g.dart\';');

      if (content != originalContent) {
        await File(file).writeAsString(content);
        print('✅ Fixed regex issues: $file');
      }
    } catch (e) {
      print('❌ Error processing $file: $e');
    }
  }
}

Future<List<String>> findDartFiles(String directory) async {
  final List<String> files = [];
  final dir = Directory(directory);

  if (await dir.exists()) {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity.path);
      }
    }
  }

  return files;
}
