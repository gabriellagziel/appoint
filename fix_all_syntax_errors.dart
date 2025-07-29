import 'dart:io';

void main() async {
  print('🔧 Starting comprehensive syntax error fixes...');

  // Fix param1 issues
  await fixParam1Issues();

  // Fix missing semicolons and brackets
  await fixBasicSyntax();

  // Fix class declarations
  await fixClassDeclarations();

  // Fix constructor issues
  await fixConstructorIssues();

  // Fix import issues
  await fixImportIssues();

  print('✅ All syntax fixes completed!');
}

Future<void> fixParam1Issues() async {
  print('🔧 Fixing param1 placeholder issues...');

  final dartFiles = await findDartFiles('lib');

  for (final file in dartFiles) {
    String content = await File(file).readAsString();

    // Replace param1 with proper syntax
    content = content.replaceAll('param1 {', 'async {');
    content = content.replaceAll('param1(', 'async(');
    content = content.replaceAll('param1)', 'async)');
    content = content.replaceAll('param1,', 'async,');
    content = content.replaceAll('param1;', 'async;');
    content = content.replaceAll('param1:', 'async:');
    content = content.replaceAll('param1 =>', 'async =>');
    content = content.replaceAll('param1 =>', 'async =>');
    content = content.replaceAll('param1}', 'async}');

    // Fix $param1 issues
    content = content.replaceAll('\$param1', 'async');
    content = content.replaceAll('param1 {', 'async {');

    // Fix specific patterns
    content = content.replaceAll(
        'param1({param}) : param', '({required this.param})');
    content = content.replaceAll(
        'param1({param}) : param variable1', '({required this.param})');
    content = content.replaceAll('class \$param1', 'class Service');
    content = content.replaceAll('final param1 final', 'final');
    content = content.replaceAll('param1 final', 'final');

    await File(file).writeAsString(content);
  }
}

Future<void> fixBasicSyntax() async {
  print('🔧 Fixing basic syntax issues...');

  final dartFiles = await findDartFiles('lib');

  for (final file in dartFiles) {
    String content = await File(file).readAsString();

    // Fix missing semicolons after class declarations
    content =
        content.replaceAll('class ([a-zA-Z_][a-zA-Z0-9_]*) {', 'class \$1 {');

    // Fix missing semicolons after variable declarations
    content = content.replaceAll(
        'final ([a-zA-Z_][a-zA-Z0-9_]*) = ([^;]+)(?!;)', 'final \$1 = \$2;');

    // Fix missing semicolons after const declarations
    content = content.replaceAll(
        'const ([a-zA-Z_][a-zA-Z0-9_]*) = ([^;]+)(?!;)', 'const \$1 = \$2;');

    // Fix missing semicolons after static declarations
    content = content.replaceAll(
        'static ([a-zA-Z_][a-zA-Z0-9_]*) = ([^;]+)(?!;)', 'static \$1 = \$2;');

    await File(file).writeAsString(content);
  }
}

Future<void> fixClassDeclarations() async {
  print('🔧 Fixing class declaration issues...');

  final dartFiles = await findDartFiles('lib');

  for (final file in dartFiles) {
    String content = await File(file).readAsString();

    // Fix malformed class declarations
    content = content.replaceAll(
        'class ([a-zA-Z_][a-zA-Z0-9_]*) {([^}]*)}', 'class \$1 {\n  \$2\n}');

    // Fix missing class names
    content = content.replaceAll('class {', 'class Service {');
    content = content.replaceAll('class \$', 'class Service');

    await File(file).writeAsString(content);
  }
}

Future<void> fixConstructorIssues() async {
  print('🔧 Fixing constructor issues...');

  final dartFiles = await findDartFiles('lib');

  for (final file in dartFiles) {
    String content = await File(file).readAsString();

    // Fix constructor syntax
    content = content.replaceAll(
        '([a-zA-Z_][a-zA-Z0-9_]*)\(([^)]*)\) : ([^;]+);', '\$1(\$2) : \$3;');
    content = content.replaceAll(
        '([a-zA-Z_][a-zA-Z0-9_]*)\(([^)]*)\) : ([^{]+){', '\$1(\$2) : \$3 {');

    // Fix missing constructor bodies
    content = content.replaceAll('([a-zA-Z_][a-zA-Z0-9_]*)\(([^)]*)\);',
        '\$1(\$2) {\n    // TODO: Implement constructor\n  }');

    await File(file).writeAsString(content);
  }
}

Future<void> fixImportIssues() async {
  print('🔧 Fixing import issues...');

  final dartFiles = await findDartFiles('lib');

  for (final file in dartFiles) {
    String content = await File(file).readAsString();

    // Fix malformed imports
    content = content.replaceAll('import ([^;]+)(?!;)', 'import \$1;');
    content = content.replaceAll('export ([^;]+)(?!;)', 'export \$1;');
    content = content.replaceAll('part ([^;]+)(?!;)', 'part \$1;');

    await File(file).writeAsString(content);
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
