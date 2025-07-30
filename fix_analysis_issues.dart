import 'dart:io';

/// Script to fix common Flutter analysis issues
void main() async {
  print('Starting to fix Flutter analysis issues...');
  
  // 1. Fix avoid_final_parameters issues
  await fixFinalParameters();
  
  // 2. Fix REDACTED_TOKEN issues
  await fixCatchClauses();
  
  // 3. Add basic documentation for public members
  await addBasicDocumentation();
  
  print('Analysis issues fix completed!');
}

Future<void> fixFinalParameters() async {
  print('Fixing avoid_final_parameters issues...');
  
  final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  for (final file in dartFiles) {
    final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
    bool final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
    
    for (int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile')); i < lines.length; i++) {
      final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
      if (line.contains('final ') && line.contains('(') && line.contains(')')) {
        // Check if this is a function parameter
        if (line.contains('=>') || line.contains('{') || line.contains(';')) {
          // This is likely a function parameter, remove 'final'
          final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
          if (newLine != line) {
            lines[i] = newLine;
            final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
            fixedCount++;
          }
        }
      }
    }
    
    if (modified) {
      await File(file).writeAsString(lines.join('\n'));
    }
  }
  
  print('Fixed $fixedCount final parameter issues');
}

Future<void> fixCatchClauses() async {
  print('Fixing REDACTED_TOKEN issues...');
  
  final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  for (final file in dartFiles) {
    final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
    bool final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
    
    for (int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile')); i < lines.length; i++) {
      final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
      if (line.trim().startsWith('} catch (') && !line.contains('on ')) {
        // Replace generic catch with specific exception
        final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
        );
        if (newLine != line) {
          lines[i] = newLine;
          final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
          fixedCount++;
        }
      }
    }
    
    if (modified) {
      await File(file).writeAsString(lines.join('\n'));
    }
  }
  
  print('Fixed $fixedCount catch clause issues');
}

Future<void> addBasicDocumentation() async {
  print('Adding basic documentation for public members...');
  
  final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  for (final file in dartFiles) {
    final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
    bool final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
    
    for (int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile')); i < lines.length; i++) {
      final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
      
      // Check for public classes, methods, or properties without documentation
      if ((line.contains('class ') || line.contains('void ') || line.contains('String ') || 
           line.contains('int ') || line.contains('bool ') || line.contains('Widget ')) &&
          !line.trim().startsWith('///') && !line.trim().startsWith('//') &&
          !line.trim().startsWith('import') && !line.trim().startsWith('part') &&
          line.contains('{') && !line.contains('abstract')) {
        
        // Add basic documentation
        final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
        
        // Insert documentation before the line
        lines.insert(i, documentation);
        final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
        fixedCount++;
        i++; // Skip the next line since we inserted one
      }
    }
    
    if (modified) {
      await File(file).writeAsString(lines.join('\n'));
    }
  }
  
  print('Added documentation for $fixedCount public members');
}

Future<List<String>> findDartFiles(String directory) param1 {
  final List<String> final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  await for (final entity in Directory(directory).list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      files.add(entity.path);
    }
  }
  
  return files;
} 