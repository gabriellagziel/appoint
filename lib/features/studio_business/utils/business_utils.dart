import 'package:appoint/models/user_type.dart';

class BusinessUtils {
  /// Convert UserType enum to string for display
  static String userTypeToString(final UserType userType) {
    switch (userType) {
      case UserType.personal:
        return 'Personal';
      case UserType.business:
        return 'Business';
      case UserType.studio:
        return 'Studio';
      case UserType.admin:
        return 'Admin';
      case UserType.child:
        return 'Child';
    }
  }

  /// Convert string to UserType enum
  static UserType stringToUserType(final String userTypeString) {
    switch (userTypeString.toLowerCase()) {
      case 'business':
        return UserType.business;
      case 'studio':
        return UserType.studio;
      case 'admin':
        return UserType.admin;
      case 'child':
        return UserType.child;
      case 'personal':
        return UserType.personal;
      default:
        return UserType.personal;
    }
  }

  /// Check if user type is a business type (business or studio)
  static bool isBusinessType(final UserType userType) {
    return userType == UserType.business || userType == UserType.studio;
  }

  /// Get the appropriate dashboard title for a user type
  static String getDashboardTitle(final UserType userType) {
    switch (userType) {
      case UserType.business:
        return 'Business Dashboard';
      case UserType.studio:
        return 'Studio Dashboard';
      case UserType.admin:
        return 'Admin Dashboard';
      case UserType.child:
        return 'Child Dashboard';
      case UserType.personal:
        return 'Personal Dashboard';
    }
  }

  /// Get the appropriate icon name for a user type
  static String getUserTypeIcon(final UserType userType) {
    switch (userType) {
      case UserType.business:
        return 'business';
      case UserType.studio:
        return 'videocam';
      case UserType.admin:
        return 'admin_panel_settings';
      case UserType.child:
        return 'child_care';
      case UserType.personal:
        return 'person';
    }
  }
}
