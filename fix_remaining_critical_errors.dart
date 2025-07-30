import 'dart:io';

void main() async {
  print('🔧 Fixing remaining critical syntax errors...');

  await fixCriticalErrors();

  print('✅ Critical error fixes completed!');
}

Future<void> fixCriticalErrors() async {
  final criticalFiles = [
    'lib/services/eta_service.dart',
    'lib/services/rewards_service.dart',
    'lib/services/form_response_service.dart',
    'lib/services/ambassador_mobile_notifications.dart',
    'lib/services/payment_service.dart',
    'lib/services/local_notification_service.dart',
    'lib/services/notification_service.dart',
    'lib/services/user_profile_service.dart',
    'lib/services/ad_service.dart',
    'lib/services/business_subscription_service.dart',
    'lib/services/ambassador_deep_link_service.dart',
    'lib/services/api/stripe_payment_service.dart',
    'lib/services/ui_notification_service.dart',
    'lib/services/offline_booking_repository.dart',
    'lib/services/api/messaging_api_service.dart',
    'lib/services/api/payment_api_service.dart',
    'lib/services/api/search_api_service.dart',
    'lib/services/performance_monitoring_service.dart',
    'lib/services/studio_profile_service.dart',
    'lib/services/family_service.dart',
    'lib/services/fcm_service.dart',
    'lib/services/api/api_client.dart',
    'lib/services/api/booking_api_service.dart',
    'lib/services/api/real_api_config.dart',
    'lib/services/usage_monitor.dart',
    'lib/services/studio_service.dart',
    'lib/services/business_analytics_service.dart',
    'lib/services/family_background_service.dart',
    'lib/services/service_error_handler.dart',
    'lib/services/storage_service.dart',
    'lib/services/error/error_handler.dart',
    'lib/services/error_handling_service.dart',
    'lib/services/performance_service.dart',
    'lib/services/ambassador_service.dart',
    'lib/services/broadcast_service.dart',
    'lib/services/notifications/push_notification_service.dart',
    'lib/services/referral_service.dart',
    'lib/services/maps_service.dart',
    'lib/services/dashboard_service.dart',
    'lib/services/content_service.dart',
    'lib/services/ambassador_analytics_service.dart',
    'lib/services/ambassador_notification_service.dart',
    'lib/services/onboarding_service.dart',
    'lib/services/broadcast_notification_handler.dart',
    'lib/services/analytics/analytics_service.dart',
  ];

  for (final file in criticalFiles) {
    try {
      if (await File(file).exists()) {
        var content = await File(file).readAsString();
        var originalContent = content;

        // Fix specific patterns
        content = fixConstructorIssues(content);
        content = fixFieldDeclarationIssues(content);
        content = fixMethodIssues(content);
        content = fixClassMemberIssues(content);
        content = fixStringLiteralIssues(content);

        if (content != originalContent) {
          await File(file).writeAsString(content);
          print('✅ Fixed: $file');
        }
      }
    } catch (e) {
      print('❌ Error processing $file: $e');
    }
  }
}

String fixConstructorIssues(String content) {
  // Fix constructor name mismatches
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\{[^}]*\}\s*\)\s*:\s*(\w+)'),
    'class \param1 {',
  );
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\)\s*:\s*(\w+)'),
    'class \param1 {',
  );

  // Fix missing constructor bodies
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\)\s*\{\s*$', multiLine: true),
    '\function1() {',
  );

  return content;
}

String fixFieldDeclarationIssues(String content) {
  // Fix field declarations without proper syntax
  content = content.replaceAll(
    RegExp(r'(\w+)\s+(\w+)\s*;\s*$', multiLine: true),
    'final \param1 \param;',
  );
  content = content.replaceAll(
    RegExp(r'(\w+)\s+(\w+)\s*=\s*([^;]+);'),
    'final \param1 \param = \param;',
  );

  // Fix missing semicolons
  content = content.replaceAll(
    RegExp(r'(\w+)\s*=\s*([^;]+)$', multiLine: true),
    '\param1 = \param;',
  );

  return content;
}

String fixMethodIssues(String content) {
  // Fix method declarations
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\)\s*\{\s*$', multiLine: true),
    '\function1() {',
  );
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\)\s*async\s*\{\s*$', multiLine: true),
    '\function1() async {',
  );

  // Fix missing method bodies
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\)\s*;\s*$', multiLine: true),
    '\function1() { }',
  );

  return content;
}

String fixClassMemberIssues(String content) {
  // Fix class members with same name as class
  content = content.replaceAll(
    RegExp(r'class\s+(\w+)\s*\{\s*(\w+)\s*;'),
    'class \param1 { final \param;',
  );

  // Fix duplicate final keywords
  content = content.replaceAll(
    RegExp(r'final\s+final\s+(\w+)'),
    'final \param1',
  );
  content = content.replaceAll(
    RegExp(r'(\w+)\s+final\s+final\s+(\w+)'),
    '\param1 final \param',
  );

  return content;
}

String fixStringLiteralIssues(String content) {
  // Fix unterminated string literals
  content = content.replaceAll(
    RegExp(r'(\w+)\s*=\s*"([^"]*)$', multiLine: true),
    '\string1 = "param1";',
  );

  // Fix missing closing brackets
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\{\s*$', multiLine: true),
    '\param1 {',
  );

  return content;
}
