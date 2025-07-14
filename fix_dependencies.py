#!/usr/bin/env python3

import re

# Read the current pubspec.yaml
with open('pubspec.yaml', 'r') as f:
    content = f.read()

# Define compatible versions for Dart SDK 3.5.4
dependency_fixes = {
    # Dev dependencies that need downgrades
    'flutter_lints': '^3.0.2',
    
    # Main dependencies that need downgrades
    'webview_flutter': '^4.7.0',  # Compatible with SDK >=3.4.0
    'firebase_core': '^2.31.1',  # Compatible version
    'cloud_firestore': '^4.17.4',  # Compatible version
    'firebase_auth': '^4.19.6',  # Compatible version
    'firebase_messaging': '^14.9.4',  # Compatible version
    'cloud_functions': '^4.7.6',  # Compatible version
    'firebase_analytics': '^10.10.7',  # Compatible version
    'firebase_storage': '^11.7.7',  # Compatible version
    'firebase_crashlytics': '^3.5.7',  # Compatible version
    'firebase_remote_config': '^4.4.7',  # Compatible version
    'firebase_app_check': '^0.2.2+9',  # Compatible version
    'firebase_performance': '^0.9.4+7',  # Compatible version
    'flutter_stripe': '^10.1.1',  # Compatible version
    'go_router': '^13.2.4',  # Compatible version
    'syncfusion_flutter_charts': '^25.2.7',  # Compatible version
    'connectivity_plus': '^5.0.2',  # Compatible version
    'dio': '^5.4.3+1',  # Compatible version
    'flutter_local_notifications': '^17.2.2',  # Compatible version
    
    # Build runner and code generation
    'build_runner': '^2.4.10',
    'freezed': '^2.5.2',
    'json_serializable': '^6.8.0',
}

# Apply fixes
for package, version in dependency_fixes.items():
    pattern = rf'(\s+{re.escape(package)}:\s*)\^[0-9]+\.[0-9]+\.[0-9]+(\+[0-9]+)?'
    replacement = rf'\1{version}'
    content = re.sub(pattern, replacement, content)

# Write the fixed pubspec.yaml
with open('pubspec.yaml', 'w') as f:
    f.write(content)

print("✅ Fixed dependency versions for Dart SDK 3.5.4 compatibility")