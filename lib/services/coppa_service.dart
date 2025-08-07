import 'package:flutter/foundation.dart';

/// COPPA (Children's Online Privacy Protection Act) service
/// Handles child account compliance and ad restrictions
class CoppaService {
  static final CoppaService _instance = CoppaService._internal();
  factory CoppaService() => _instance;
  CoppaService._internal();

  /// Minimum age for showing ads (13 years old)
  static const int _minimumAdAge = 13;

  /// Checks if a user is a child account (under 13)
  static bool isChildAccount({
    required DateTime? birthDate,
    required bool isChildAccountFlag,
  }) {
    if (isChildAccountFlag) return true;

    if (birthDate == null) return false;

    final now = DateTime.now();
    final age = now.year - birthDate.year;

    // Check if birthday has occurred this year
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return age - 1 < _minimumAdAge;
    }

    return age < _minimumAdAge;
  }

  /// Checks if ads should be shown for a user based on COPPA compliance
  static bool shouldShowAds({
    required DateTime? birthDate,
    required bool isChildAccountFlag,
    required bool isPremium,
    required bool isAdminFreeAccess,
  }) {
    // Don't show ads for premium or admin users
    if (isPremium || isAdminFreeAccess) return false;

    // Don't show ads for child accounts
    if (isChildAccount(
      birthDate: birthDate,
      isChildAccountFlag: isChildAccountFlag,
    )) {
      return false;
    }

    return true;
  }

  /// Validates age for COPPA compliance
  static bool isValidAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.year - birthDate.year;

    // Check if birthday has occurred this year
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      return age - 1 >= 13;
    }

    return age >= 13;
  }

  /// Gets age from birth date
  static int getAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;

    // Check if birthday has occurred this year
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  /// Formats age for display
  static String formatAge(DateTime birthDate) {
    final age = getAge(birthDate);
    return '$age years old';
  }

  /// Checks if user needs parental consent
  static bool needsParentalConsent({
    required DateTime? birthDate,
    required bool isChildAccountFlag,
  }) {
    if (isChildAccountFlag) return true;

    if (birthDate == null) return false;

    return !isValidAge(birthDate);
  }

  /// Logs COPPA compliance check
  static void logCoppaCheck({
    required String userId,
    required bool isChildAccount,
    required bool adsDisabled,
    required String reason,
  }) {
    debugPrint(
      'COPPA Check - User: $userId, Child: $isChildAccount, Ads Disabled: $adsDisabled, Reason: $reason',
    );

    // TODO: Log to analytics service
    // AnalyticsService.logEvent('coppa_check', params: {
    //   'userId': userId,
    //   'isChildAccount': isChildAccount,
    //   'adsDisabled': adsDisabled,
    //   'reason': reason,
    // });
  }

  /// Gets COPPA compliance status for a user
  static Map<String, dynamic> getComplianceStatus({
    required DateTime? birthDate,
    required bool isChildAccountFlag,
    required bool isPremium,
    required bool isAdminFreeAccess,
  }) {
    final isChild = isChildAccount(
      birthDate: birthDate,
      isChildAccountFlag: isChildAccountFlag,
    );

    final shouldShowAds = CoppaService.shouldShowAds(
      birthDate: birthDate,
      isChildAccountFlag: isChildAccountFlag,
      isPremium: isPremium,
      isAdminFreeAccess: isAdminFreeAccess,
    );

    final needsConsent = needsParentalConsent(
      birthDate: birthDate,
      isChildAccountFlag: isChildAccountFlag,
    );

    String reason = 'Unknown';
    if (isPremium) {
      reason = 'Premium user';
    } else if (isAdminFreeAccess) {
      reason = 'Admin access';
    } else if (isChild) {
      reason = 'Child account (COPPA compliance)';
    } else {
      reason = 'Eligible for ads';
    }

    return {
      'isChildAccount': isChild,
      'shouldShowAds': shouldShowAds,
      'needsParentalConsent': needsConsent,
      'reason': reason,
      'age': birthDate != null ? getAge(birthDate) : null,
      'formattedAge': birthDate != null ? formatAge(birthDate) : null,
    };
  }
}
