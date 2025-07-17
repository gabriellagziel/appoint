/// Environment configuration for the APP-OINT application.
///
/// This file centralizes all environment variables used throughout the application.
/// All sensitive configuration should be loaded from environment variables
/// rather than hardcoded in the source code.
class EnvironmentConfig {
  // Private constructor to prevent instantiation
  EnvironmentConfig._();

  // Stripe Configuration
  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
  );

  static const String stripeCheckoutUrl = String.fromEnvironment(
    'STRIPE_CHECKOUT_URL',
    defaultValue: 'https://checkout.stripe.com/pay',
  );

  // API Configuration
  static const String familyApiBaseUrl = String.fromEnvironment(
    'FAMILY_API_BASE_URL',
    defaultValue: 'https://api.yourapp.com/api/v1/family',
  );

  // Authentication Configuration
  static const String authRedirectUri = String.fromEnvironment(
    'AUTH_REDIRECT_URI',
    defaultValue: 'http://localhost:8080/__/auth/handler',
  );

  // Deep Link Configuration
  static const String deepLinkBaseUrl = String.fromEnvironment(
    'DEEP_LINK_BASE_URL',
    defaultValue: 'https://app-oint-core.web.app',
  );

  // WhatsApp Configuration
  static const String whatsappBaseUrl = String.fromEnvironment(
    'WHATSAPP_BASE_URL',
    defaultValue: 'https://app-oint-core.web.app',
  );

  static const String whatsappApiUrl = String.fromEnvironment(
    'WHATSAPP_API_URL',
    defaultValue: 'https://wa.me/?text=',
  );

  // Firebase Configuration (if needed for custom endpoints)
  static const String firebaseProjectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
  );

  // Google Services Configuration
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
  );

  // Validation methods
  static bool get isStripeConfigured => stripePublishableKey.isNotEmpty;
  static bool get isFirebaseConfigured => firebaseProjectId.isNotEmpty;
  static bool get isGoogleConfigured => googleClientId.isNotEmpty;

  /// Validate that all required environment variables are set
  static List<String> validateRequiredConfig() {
    final missing = <String>[];

    if (!isStripeConfigured) {
      missing.add('STRIPE_PUBLISHABLE_KEY');
    }

    if (!isFirebaseConfigured) {
      missing.add('FIREBASE_PROJECT_ID');
    }

    return missing;
  }

  /// Get a summary of the current configuration
  static Map<String, String> getConfigSummary() => {
        'stripe_configured': isStripeConfigured.toString(),
        'firebase_configured': isFirebaseConfigured.toString(),
        'google_configured': isGoogleConfigured.toString(),
        'family_api_url': familyApiBaseUrl,
        'auth_redirect_uri': authRedirectUri,
        'deep_link_base_url': deepLinkBaseUrl,
        'whatsapp_base_url': whatsappBaseUrl,
      };
}
