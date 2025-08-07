import 'dart:io';

void main() async {
  print('🔧 Fixing model annotations and generated code issues...');

  await fixModelAnnotations();
  await fixGeneratedCodeIssues();
  await fixMissingPartDirectives();

  print('✅ Model fixes completed!');
}

Future<void> fixModelAnnotations() async {
  print('🔧 Fixing model annotations...');

  final modelFiles = [
    'lib/models/user_profile.dart',
    'lib/models/appointment.dart',
    'lib/models/business_profile.dart',
    'lib/models/ambassador_profile.dart',
    'lib/models/app_user.dart',
    'lib/models/meeting.dart',
    'lib/models/event_features.dart',
    'lib/models/content_item.dart',
    'lib/models/hive_adapters.dart',
    'lib/models/offline_booking.dart',
    'lib/models/offline_service_offering.dart',
    'lib/models/support_ticket.dart',
    'lib/models/branch.dart',
    'lib/models/organization.dart',
    'lib/models/provider.dart',
    'lib/models/admin_user.dart',
    'lib/models/analytics.dart',
  ];

  for (final file in modelFiles) {
    if (await File(file).exists()) {
      String content = await File(file).readAsString();

      // Fix @freezed annotations
      content = content.replaceAll('@freezed', '@freezed\nclass');
      content = content.replaceAll(
          'class ([a-zA-Z_][a-zA-Z0-9_]*) with', 'class \$1 with');

      // Fix @JsonSerializable annotations
      content = content.replaceAll('@JsonSerializable', '@JsonSerializable()');

      // Fix missing part directives
      if (content.contains('@freezed') && !content.contains("part '")) {
        final className = RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*)')
            .firstMatch(content)
            ?.group(1);
        if (className != null) {
          content = content.replaceFirst('@freezed',
              '@freezed\npart \'${className.toLowerCase()}.freezed.dart\';\npart \'${className.toLowerCase()}.g.dart\';');
        }
      }

      // Fix missing fromJson/toJson methods
      if (content.contains('@JsonSerializable') &&
          !content.contains('fromJson')) {
        content =
            content.replaceFirst('class', 'class with _\${className}JsonMixin');
      }

      await File(file).writeAsString(content);
      print('✅ Fixed: $file');
    }
  }
}

Future<void> fixGeneratedCodeIssues() async {
  print('🔧 Fixing generated code issues...');

  final generatedFiles = [
    'lib/models/user_profile.dart',
    'lib/models/appointment.dart',
    'lib/models/business_profile.dart',
  ];

  for (final file in generatedFiles) {
    if (await File(file).exists()) {
      String content = await File(file).readAsString();

      // Fix missing PlaytimePreferences methods
      if (content.contains('PlaytimePreferences') &&
          !content.contains('_\$PlaytimePreferencesFromJson')) {
        content = content.replaceAll('_\$PlaytimePreferencesFromJson(json);',
            'PlaytimePreferences.fromJson(json);');
        content = content.replaceAll(
            '_\$PlaytimePreferencesToJson(this);', 'toJson();');
      }

      // Fix field formal parameters
      content = content.replaceAll('required this.', 'required ');
      content = content.replaceAll('this.', '');

      await File(file).writeAsString(content);
      print('✅ Fixed generated code: $file');
    }
  }
}

Future<void> fixMissingPartDirectives() async {
  print('🔧 Fixing missing part directives...');

  final files = await findDartFiles('lib');

  for (final file in files) {
    if (file.contains('models/') ||
        file.contains('providers/') ||
        file.contains('services/')) {
      String content = await File(file).readAsString();

      // Add missing part directives for freezed classes
      if (content.contains('@freezed') && !content.contains('part \'')) {
        final className = RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*)')
            .firstMatch(content)
            ?.group(1);
        if (className != null) {
          final partDirectives =
              '\npart \'${className.toLowerCase()}.freezed.dart\';\npart \'${className.toLowerCase()}.g.dart\';\n';
          content = content.replaceFirst('@freezed', '@freezed$partDirectives');
        }
      }

      // Add missing part directives for JsonSerializable classes
      if (content.contains('@JsonSerializable') &&
          !content.contains('part \'') &&
          !content.contains('@freezed')) {
        final className = RegExp(r'class ([a-zA-Z_][a-zA-Z0-9_]*)')
            .firstMatch(content)
            ?.group(1);
        if (className != null) {
          final partDirective =
              '\npart \'${className.toLowerCase()}.g.dart\';\n';
          content = content.replaceFirst(
              '@JsonSerializable()', '@JsonSerializable()$partDirective');
        }
      }

      await File(file).writeAsString(content);
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
