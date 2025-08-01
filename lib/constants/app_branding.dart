/// APP-OINT Branding Constants
/// This file contains all branding-related constants for the APP-OINT platform
library;

class AppBranding {
  // App Name
  static const String appName = 'APP-OINT';
  static const String appNameShort = 'AppOint';

  // Official Slogan - DO NOT TRANSLATE
  static const String slogan = 'Time Organized';
  static const String sloganSubtitle = 'Set Send Done';
  static const String fullSlogan = '$slogan • $sloganSubtitle';

  // Logo Assets
  static const String logoPath = 'assets/images/app_oint_logo.svg';
  static const String logoIconPath = 'assets/images/app_oint_logo.svg';
  static const String faviconPath = 'web/favicon.png';

  // App Icons
  static const String appIconPath = 'assets/images/app_icon.png';
  static const String appIconMaskablePath =
      'assets/images/app_icon_maskable.png';

  // Brand Colors (extracted from the logo)
  static const int primaryOrange = 0xFFFF8C00; // Top figure
  static const int primaryPeach = 0xFFFFB366; // Top-right figure
  static const int primaryTeal = 0xFF20B2AA; // Right figure
  static const int primaryPurple = 0xFF8A2BE2; // Bottom-right figure
  static const int primaryDarkPurple = 0xFF4B0082; // Bottom figure
  static const int primaryBlue = 0xFF4169E1; // Bottom-left figure
  static const int primaryGreen = 0xFF32CD32; // Left figure
  static const int primaryYellow = 0xFFFFD700; // Top-left figure

  // Logo Colors List
  static const List<int> logoColors = [
    primaryOrange,
    primaryPeach,
    primaryTeal,
    primaryPurple,
    primaryDarkPurple,
    primaryBlue,
    primaryGreen,
    primaryYellow,
  ];

  // Meta Description
  static const String metaDescription =
      'APP-OINT - Time Organized. Set Send Done. Your Healthcare Appointment Platform';

  // App Store Description
  static const String appStoreDescription =
      'APP-OINT: Time Organized. Set Send Done. Streamline your healthcare appointments with our comprehensive platform.';
}
