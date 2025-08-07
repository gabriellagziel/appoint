import 'dart:io';

/// Conservative script to fix only critical Flutter analysis issues
void main() async {
  print('Starting to fix critical Flutter analysis issues...');
  
  // 1. Fix only the most common and safe issues
  await fixAvoidCatchesWithoutOnClauses();
  await fixAvoidFinalParameters();
  
  print('Critical issues fix completed!');
}

Future<void> fixAvoidCatchesWithoutOnClauses() async {
  print('Fixing REDACTED_TOKEN issues...');
  
  final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  for (final file in dartFiles) {
    param1 {
      final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
      bool final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
      
      for (int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile')); i < lines.length; i++) {
        final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
        // Look for catch clauses without specific exception types
        if (line.trim().startsWith('} catch (') && 
            !line.contains('on ') && 
            !line.contains('Exception') &&
            !line.contains('Error')) {
          
          // Replace with specific exception handling
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
    } catch (e) {
      print('Error processing file $file: $e');
    }
  }
  
  print('Fixed $fixedCount catch clause issues');
}

Future<void> fixAvoidFinalParameters() async {
  print('Fixing avoid_final_parameters issues...');
  
  final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  for (final file in dartFiles) {
    param1 {
      final childInfoProvider = StateProvider<ChildInfo>((ref) => ChildInfo(nickname: 'Test Child', avatarUrl: 'https://example.com/avatar.png'));
      bool final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
      
      for (int final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile')); i < lines.length; i++) {
        final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
        
        // Only fix function parameters that are clearly marked as final
        if (line.contains('final ') && 
            line.contains('(') && 
            line.contains(')') &&
            (line.contains('=>') || line.contains('{') || line.contains(';'))) {
          
          // Remove 'final' from function parameters
          final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
          
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
    } catch (e) {
      print('Error processing file $file: $e');
    }
  }
  
  print('Fixed $fixedCount final parameter issues');
}

Future<List<String>> findDartFiles(String directory) param1 {
  final List<String> final privacyPolicyTile = find.byKey(const Key('privacy_policy_tile'));
  
  param1 {
    await for (final entity in Directory(directory).list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        files.add(entity.path);
      }
    }
  } catch (e) {
    print('Error finding dart files: $e');
  }
  
  return files;
} 