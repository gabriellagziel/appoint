#!/usr/bin/env dart

/// Environment validation script for APP-OINT
///
/// This script validates that all required environment variables are properly configured.
/// Run this script to check your environment setup before running the application.

import 'dart:io';

void main(List<String> args) {
  print('🔍 APP-OINT Environment Validation');
  print('===================================\n');

  final issues = <String>[];
  final warnings = <String>[];
  final successes = <String>[];

  // Check required environment variables
  final requiredVars = {
    'STRIPE_PUBLISHABLE_KEY': 'Required for payment processing',
    'FIREBASE_PROJECT_ID': 'Required for Firebase services',
    'GOOGLE_CLIENT_ID': 'Required for Google OAuth authentication',
  };

  // Check optional environment variables
  final optionalVars = {
    'FAMILY_API_BASE_URL': 'Defaults to https://api.yourapp.com/api/v1/family',
    'AUTH_REDIRECT_URI': 'Defaults to http://localhost:8080/__/auth/handler',
    'DEEP_LINK_BASE_URL': 'Defaults to https://app-oint-core.web.app',
    'WHATSAPP_BASE_URL': 'Defaults to https://app-oint-core.web.app',
    'WHATSAPP_API_URL': 'Defaults to https://wa.me/?text=',
    'STRIPE_CHECKOUT_URL': 'Defaults to https://checkout.stripe.com/pay',
  };

  print('Checking required environment variables...\n');

  for (final entry in requiredVars.entries) {
    final value = Platform.environment[entry.key];
    if (value == null || value.isEmpty) {
      issues.add('❌ ${entry.key}: ${entry.value}');
    } else {
      successes.add('✅ ${entry.key}: Set');
    }
  }

  print('Checking optional environment variables...\n');

  for (final entry in optionalVars.entries) {
    final value = Platform.environment[entry.key];
    if (value == null || value.isEmpty) {
      warnings.add('⚠️  ${entry.key}: Not set (${entry.value})');
    } else {
      successes.add('✅ ${entry.key}: Set');
    }
  }

  // Check for .env file
  final envFile = File('.env');
  if (!envFile.existsSync()) {
    warnings.add('⚠️  .env file not found in project root');
  } else {
    successes.add('✅ .env file found');
  }

  // Check for .gitignore
  final gitignoreFile = File('.gitignore');
  if (gitignoreFile.existsSync()) {
    final gitignoreContent = gitignoreFile.readAsStringSync();
    if (gitignoreContent.contains('.env')) {
      successes.add('✅ .env is in .gitignore');
    } else {
      warnings.add('⚠️  .env is not in .gitignore (security risk)');
    }
  } else {
    warnings.add('⚠️  .gitignore file not found');
  }

  // Print results
  if (successes.isNotEmpty) {
    print('✅ Successes:');
    for (final success in successes) {
      print('  $success');
    }
    print('');
  }

  if (warnings.isNotEmpty) {
    print('⚠️  Warnings:');
    for (final warning in warnings) {
      print('  $warning');
    }
    print('');
  }

  if (issues.isNotEmpty) {
    print('❌ Issues (must be fixed):');
    for (final issue in issues) {
      print('  $issue');
    }
    print('');
  }

  // Summary
  print('📊 Summary:');
  print('  ✅ Successes: ${successes.length}');
  print('  ⚠️  Warnings: ${warnings.length}');
  print('  ❌ Issues: ${issues.length}');
  print('');

  if (issues.isNotEmpty) {
    print('❌ Environment validation failed!');
    print('Please fix the issues above before running the application.');
    print('');
    print('📖 For help, see: docs/environment_setup.md');
    exit(1);
  } else if (warnings.isNotEmpty) {
    print('⚠️  Environment validation passed with warnings.');
    print('The application will work, but consider addressing the warnings.');
    print('');
    print('📖 For help, see: docs/environment_setup.md');
  } else {
    print('✅ Environment validation passed!');
    print('Your environment is properly configured.');
  }

  print('');
  print('🚀 Next steps:');
  print('  1. Run: flutter pub get');
  print('  2. Run: dart run build_runner build --delete-conflicting-outputs');
  print('  3. Run: flutter gen-l10n');
  print('  4. Run: flutter run');
}
