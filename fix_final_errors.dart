import 'dart:io';

void main() async {
  print('🔧 Fixing final critical syntax errors...');

  await fixFinalErrors();

  print('✅ Final error fixes completed!');
}

Future<void> fixFinalErrors() async {
  final criticalFiles = [
    'lib/theme/sample_palettes.dart',
    'lib/services/firestore_service.dart',
    'lib/services/staff_availability_service.dart',
    'lib/services/location_service.dart',
    'lib/services/permission_service.dart',
    'lib/theme/app_colors.dart',
    'lib/models/invite.dart',
    'lib/models/booking.dart',
    'lib/features/onboarding/onboarding_screen.dart',
    'lib/utils/color_extensions.dart',
    'lib/models/meeting.dart',
    'lib/features/child/providers/child_providers.dart',
    'lib/utils/datetime_converter.dart',
    'lib/models/app_user.dart',
    'lib/utils/business_helpers.dart',
    'lib/features/billing/screens/subscription_screen.dart',
    'lib/shared/widgets/responsive_scaffold.dart',
    'lib/features/onboarding/screens/enhanced_onboarding_screen.dart',
    'lib/models/ambassador_profile.dart',
    'lib/services/business_profile_service.dart',
    'lib/utils/booking_helper.dart',
    'lib/models/personal_appointment.dart',
    'lib/services/admin_service.dart',
    'lib/services/ambassador_quota_service.dart',
    'lib/services/calendar_service.dart',
    'lib/examples/notification_integration_example.dart',
    'lib/models/branch.dart',
    'lib/services/analytics_service.dart',
    'lib/services/broadcast_scheduler_service.dart',
    'lib/services/google_calendar_service.dart',
    'lib/services/search_service.dart',
    'lib/services/whatsapp_share_service.dart',
    'lib/services/stripe_service.dart',
    'lib/services/appointment_service.dart',
    'lib/services/care_provider_service.dart',
    'lib/services/security_service.dart',
    'lib/services/user_deletion_service.dart',
    'lib/services/auth_service.dart',
    'lib/services/meeting_service.dart',
    'lib/services/ambassador_automation_service.dart',
    'lib/services/broadcast_config.dart',
    'lib/services/user_settings_service.dart',
    'lib/services/invite_service.dart',
    'lib/services/branch_service.dart',
    'lib/widgets/responsive_scaffold.dart',
    'lib/services/comment_service.dart',
    'lib/widgets/app_attribution.dart',
    'lib/widgets/app_shell.dart',
    'lib/services/studio_appointment_service.dart',
    'lib/widgets/calendar/tablet_calendar_overflow_handler.dart',
    'lib/services/personal_scheduler_service.dart',
    'lib/services/playtime_service.dart',
    'lib/services/custom_deep_link_service.dart',
    'lib/widgets/search_bar.dart',
    'lib/widgets/forms/inline_error_hints.dart',
    'lib/widgets/booking_confirmation_sheet.dart',
    'lib/widgets/feedback/animated_wrapper.dart',
    'lib/widgets/booking_blocker_modal.dart',
    'lib/widgets/booking/booking_slot_chip.dart',
    'lib/widgets/error_boundary.dart',
    'lib/widgets/timezone_selector.dart',
    'lib/widgets/admin_guard.dart',
    'lib/widgets/form_builder.dart',
    'lib/widgets/app_logo.dart',
    'lib/widgets/fcm_token_status_widget.dart',
    'lib/widgets/whatsapp_share_button.dart',
    'lib/widgets/loading_indicator.dart',
    'lib/widgets/booking_conflict_dialog.dart',
    'lib/widgets/app_scaffold.dart',
    'lib/widgets/empty_state.dart',
    'lib/widgets/bottom_sheet_manager.dart',
    'lib/widgets/accessibility/accessible_button.dart',
    'lib/widgets/accessibility/accessibility_enhancements.dart',
    'lib/widgets/social_account_conflict_dialog.dart',
    'lib/widgets/animations/fade_slide_route.dart',
    'lib/widgets/animations/list_item_entry.dart',
    'lib/widgets/animations/fade_slide_page_route.dart',
    'lib/widgets/animations/tap_scale_feedback.dart',
    'lib/widgets/animations/press_feedback.dart',
    'lib/widgets/onboarding/onboarding_screen.dart',
    'lib/widgets/animations/fade_slide_in.dart',
    'lib/widgets/business_header_widget.dart',
    'lib/widgets/auth_wrapper.dart',
    'lib/widgets/resume_last_order_button.dart',
    'lib/widgets/splash_screen.dart',
    'lib/auth_wrapper.dart',
    'lib/widgets/debug/fcm_token_debug_widget.dart',
    'lib/services/family_support_service.dart',
  ];

  for (final file in criticalFiles) {
    try {
      if (await File(file).exists()) {
        var content = await File(file).readAsString();
        var originalContent = content;

        // Fix specific patterns
        content = fixUnexpectedText(content);
        content = fixDuplicateFinalKeywords(content);
        content = fixMissingSemicolons(content);
        content = fixConstructorIssues(content);
        content = fixFieldDeclarationIssues(content);
        content = fixMethodIssues(content);
        content = fixClassMemberIssues(content);
        content = fixStringLiteralIssues(content);
        content = fixBracketSyntax(content);

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

String fixUnexpectedText(String content) {
  // Fix unexpected text like param1
  content = content.replaceAll(RegExp(r'\\\param1'), '');

  return content;
}

String fixDuplicateFinalKeywords(String content) {
  // Fix duplicate final keywords
  content = content.replaceAll(RegExp(r'final\s+final\s+'), 'final ');
  content = content.replaceAll(
    RegExp(r'final\s+(\w+)\s+final\s+'),
    'final \param1 ',
  );
  content = content.replaceAll(
    RegExp(r'(\w+)\s+final\s+final\s+'),
    '\param1 final ',
  );

  // Fix final in wrong places
  content = content.replaceAll(RegExp(r'get\s+final\s+(\w+)'), 'get \param1');
  content = content.replaceAll(RegExp(r'set\s+final\s+(\w+)'), 'set \param1');
  content = content.replaceAll(
    RegExp(r'const\s+final\s+(\w+)'),
    'const \param1',
  );
  content = content.replaceAll(RegExp(r'var\s+final\s+(\w+)'), 'final \param1');

  return content;
}

String fixMissingSemicolons(String content) {
  // Fix missing semicolons after variable declarations
  content = content.replaceAll(
    RegExp(r'(\w+)\s*=\s*([^;]+)$', multiLine: true),
    '\param1 = \param;',
  );

  // Fix missing semicolons after method calls
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\(\s*\)\s*$', multiLine: true),
    '\function1();',
  );

  return content;
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
    RegExp(r'final\s+(\w+)\s+final\s+(\w+)'),
    'final \param1 \param',
  );
  content = content.replaceAll(
    RegExp(r'const\s+(\w+)\s+final\s+(\w+)'),
    'const \param1 \param',
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

String fixBracketSyntax(String content) {
  // Fix missing closing brackets
  content = content.replaceAll(
    RegExp(r'(\w+)\s*\{\s*$', multiLine: true),
    '\param1 {',
  );

  return content;
}
