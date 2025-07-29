import 'dart:io';

void main() async {
  print('🔧 Starting comprehensive syntax fixes...');
  
  await fixAllSyntaxErrors();
  
  print('✅ All comprehensive syntax fixes completed!');
}

Future<void> fixAllSyntaxErrors() async {
  final dartFiles = await findDartFiles('lib');
  
  for (final file in dartFiles) {
    try {
      String content = await File(file).readAsString();
      String originalContent = content;
      
      // Fix 1: Remove unexpected semicolons after class names
      content = content.replaceAll(RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*);'), 'class \$1 {');
      
      // Fix 2: Fix malformed class declarations
      content = content.replaceAll(RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*) {([^}]*)}'), 'class \$1 {\n  \$2\n}');
      
      // Fix 3: Fix missing semicolons after variable declarations
      content = content.replaceAll(RegExp(r'final ([a-zA-Z_][a-zA-Z0-9_]*) = ([^;]+)(?!;)'), 'final \$1 = \$2;');
      content = content.replaceAll(RegExp(r'const ([a-zA-Z_][a-zA-Z0-9_]*) = ([^;]+)(?!;)'), 'const \$1 = \$2;');
      content = content.replaceAll(RegExp(r'static ([a-zA-Z_][a-zA-Z0-9_]*) = ([^;]+)(?!;)'), 'static \$1 = \$2;');
      
      // Fix 4: Fix constructor syntax
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\(([^)]*)\) : ([^;]+);'), '\$1(\$2) : \$3;');
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\(([^)]*)\) : ([^{]+){'), '\$1(\$2) : \$3 {');
      
      // Fix 5: Fix missing constructor bodies
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\(([^)]*)\);'), '\$1(\$2) {\n    // TODO: Implement constructor\n  }');
      
      // Fix 6: Fix field formal parameters in wrong places
      content = content.replaceAll(RegExp(r'required this\.([a-zA-Z_][a-zA-Z0-9_]*)'), 'required \$1');
      content = content.replaceAll(RegExp(r'this\.([a-zA-Z_][a-zA-Z0-9_]*)'), '\$1');
      
      // Fix 7: Fix malformed imports
      content = content.replaceAll(RegExp(r'import ([^;]+)(?!;)'), 'import \$1;');
      content = content.replaceAll(RegExp(r'export ([^;]+)(?!;)'), 'export \$1;');
      content = content.replaceAll(RegExp(r'part ([^;]+)(?!;)'), 'part \$1;');
      
      // Fix 8: Fix function expressions
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*) => ([^;]+)'), '(\$1) => \$2');
      
      // Fix 9: Fix missing semicolons after method calls
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*\([^)]*\))(?!;)'), '\$1;');
      
      // Fix 10: Fix malformed class members
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\s*{\s*([^}]*)\s*}'), '\$1 {\n    \$2\n  }');
      
      // Fix 11: Fix missing closing brackets
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\s*{\s*([^{}]*(?:{[^{}]*})*[^{}]*)\s*$'), '\$1 {\n    \$2\n  }');
      
      // Fix 12: Fix malformed annotations
      content = content.replaceAll('@freezed', '@freezed\nclass');
      content = content.replaceAll('@JsonSerializable', '@JsonSerializable()');
      
      // Fix 13: Fix missing part directives for freezed
      if (content.contains('@freezed') && !content.contains("part '")) {
        final className = RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*)').firstMatch(content)?.group(1);
        if (className != null) {
          content = content.replaceFirst('@freezed', '@freezed\npart \'${className.toLowerCase()}.freezed.dart\';\npart \'${className.toLowerCase()}.g.dart\';');
        }
      }
      
      // Fix 14: Fix missing part directives for JsonSerializable
      if (content.contains('@JsonSerializable()') && !content.contains('part \'') && !content.contains('@freezed')) {
        final className = RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*)').firstMatch(content)?.group(1);
        if (className != null) {
          content = content.replaceFirst('@JsonSerializable()', '@JsonSerializable()\npart \'${className.toLowerCase()}.g.dart\';');
        }
      }
      
      // Fix 15: Fix malformed method declarations
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\s*\(([^)]*)\)\s*{\s*([^}]*)\s*}'), '\$1(\$2) {\n    \$3\n  }');
      
      // Fix 16: Fix missing return types
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\s*\(([^)]*)\)\s*{'), 'void \$1(\$2) {');
      
      // Fix 17: Fix malformed variable declarations
      content = content.replaceAll(RegExp(r'([a-zA-Z_][a-zA-Z0-9_]*)\s*=\s*([^;]+)(?!;)'), '\$1 = \$2;');
      
      // Fix 18: Fix malformed string literals
      content = content.replaceAll(RegExp(r"'([^']*)'([^;]*)$"), "'\$1'\$2;");
      
      // Fix 19: Fix malformed list declarations
      content = content.replaceAll(RegExp(r'\[\s*([^\]]*)\s*\]\s*$'), '[\$1];');
      
      // Fix 20: Fix malformed map declarations
      content = content.replaceAll(RegExp(r'{\s*([^}]*)\s*}\s*$'), '{\$1};');
      
      if (content != originalContent) {
        await File(file).writeAsString(content);
        print('✅ Fixed: $file');
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