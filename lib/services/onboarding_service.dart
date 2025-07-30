import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  OnboardingService._internal();
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _onboardingVersionKey = 'onboarding_version';
  static const String _currentOnboardingVersion = '1.0.0';

  static OnboardingService? _instance;
  static OnboardingService get instance =>
      _instance ??= OnboardingService._internal();

  /// Check if onboarding has been completed
  Future<bool> isOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final completed = prefs.getBool(_onboardingCompletedKey) ?? false;
      final version = prefs.getString(_onboardingVersionKey);

      // If version changed, reset onboarding
      if (version != _currentOnboardingVersion) {
        await prefs.remove(_onboardingCompletedKey);
        return false;
      }

      return completed;
    } catch (e) {
      // If there's an error, assume onboarding is not completed
      return false;
    }
  }

  /// Mark onboarding as completed
  Future<void> markOnboardingComplete() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      await prefs.setString(_onboardingVersionKey, _currentOnboardingVersion);
    } catch (e) {
      throw Exception('Failed to mark onboarding as complete: $e');
    }
  }

  /// Reset onboarding (for testing or if user wants to see it again)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
      await prefs.remove(_onboardingVersionKey);
    } catch (e) {
      throw Exception('Failed to reset onboarding: $e');
    }
  }

  /// Get onboarding version
  Future<String?> getOnboardingVersion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_onboardingVersionKey);
    } catch (e) {
      return null;
    }
  }

  /// Check if onboarding should be shown (for new users or version updates)
  Future<bool> shouldShowOnboarding() async => !await isOnboardingCompleted();
}
