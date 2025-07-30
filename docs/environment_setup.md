# Environment Configuration Setup

This document describes how to configure environment variables for the APP-OINT application.

## Overview

The APP-OINT application uses environment variables to manage sensitive configuration such as API keys, service URLs, and other external service credentials. This approach ensures that sensitive data is not hardcoded in the source code and can be easily managed across different environments (development, staging, production).

## Required Environment Variables

### Stripe Configuration
- `STRIPE_PUBLISHABLE_KEY`: Your Stripe publishable key (starts with `pk_test_` for test mode or `pk_live_` for live mode)
- `STRIPE_CHECKOUT_URL`: Stripe checkout URL (defaults to `https://checkout.stripe.com/pay`)

### API Configuration
- `FAMILY_API_BASE_URL`: Base URL for the family API service (defaults to `https://api.yourapp.com/api/v1/family`)

### Authentication Configuration
- `AUTH_REDIRECT_URI`: OAuth redirect URI for authentication (defaults to `http://localhost:8080/__/auth/handler`)

### Deep Link Configuration
- `DEEP_LINK_BASE_URL`: Base URL for deep links (defaults to `https://app-oint-core.web.app`)

### WhatsApp Configuration
- `WHATSAPP_BASE_URL`: Base URL for WhatsApp sharing (defaults to `https://app-oint-core.web.app`)
- `WHATSAPP_API_URL`: WhatsApp API URL (defaults to `https://wa.me/?text=`)

### Firebase Configuration
- `FIREBASE_PROJECT_ID`: Your Firebase project ID

### Google Services Configuration
- `GOOGLE_CLIENT_ID`: Google OAuth client ID

## Setting Up Environment Variables

### For Local Development

1. **Create a `.env` file** in the project root:
```bash
# Stripe Configuration
STRIPE_PUBLISHABLE_KEY=pk_test_your_stripe_key_here
STRIPE_CHECKOUT_URL=https://checkout.stripe.com/pay

# API Configuration
FAMILY_API_BASE_URL=https://api.yourapp.com/api/v1/family

# Authentication Configuration
AUTH_REDIRECT_URI=http://localhost:8080/__/auth/handler

# Deep Link Configuration
DEEP_LINK_BASE_URL=https://app-oint-core.web.app

# WhatsApp Configuration
WHATSAPP_BASE_URL=https://app-oint-core.web.app
WHATSAPP_API_URL=https://wa.me/?text=

# Firebase Configuration
FIREBASE_PROJECT_ID=your-firebase-project-id

# Google Services Configuration
GOOGLE_CLIENT_ID=your-google-client-id
```

2. **Add `.env` to `.gitignore** to prevent committing sensitive data:
```bash
echo ".env" >> .gitignore
```

3. **Load environment variables** in your development environment:
   - For Flutter: Use `--dart-define` flags when running the app
   - For VS Code: Configure launch.json with environment variables
   - For Android Studio: Configure run configurations with environment variables

### For Flutter Development

When running Flutter commands, pass environment variables using `--dart-define`:

```bash
flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here \
            --dart-define=FIREBASE_PROJECT_ID=your-project-id \
            --dart-define=GOOGLE_CLIENT_ID=your-client-id
```

### For VS Code

Create or update `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "args": [
        "--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here",
        "--dart-define=FIREBASE_PROJECT_ID=your-project-id",
        "--dart-define=GOOGLE_CLIENT_ID=your-client-id"
      ]
    }
  ]
}
```

### For Android Studio

1. Open Run/Debug Configurations
2. Add VM options with environment variables:
```
--dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_your_key_here
--dart-define=FIREBASE_PROJECT_ID=your-project-id
--dart-define=GOOGLE_CLIENT_ID=your-client-id
```

## CI/CD Configuration

### GitHub Actions

Add environment variables to your GitHub repository secrets:

1. Go to your repository settings
2. Navigate to Secrets and variables > Actions
3. Add the following secrets:
   - `STRIPE_PUBLISHABLE_KEY`
   - `FIREBASE_PROJECT_ID`
   - `GOOGLE_CLIENT_ID`
   - `FAMILY_API_BASE_URL`
   - `AUTH_REDIRECT_URI`
   - `DEEP_LINK_BASE_URL`
   - `WHATSAPP_BASE_URL`
   - `WHATSAPP_API_URL`

### Firebase Functions

For Firebase Functions, set environment variables using the Firebase CLI:

```bash
firebase functions:config:set stripe.publishable_key="pk_test_your_key_here"
firebase functions:config:set firebase.project_id="your-project-id"
firebase functions:config:set google.client_id="your-client-id"
```

## Environment Validation

The application includes built-in validation for required environment variables. The `EnvironmentConfig` class provides methods to validate configuration:

```dart
// Check if all required variables are set
final missingVars = EnvironmentConfig.validateRequiredConfig();
if (missingVars.isNotEmpty) {
  print('Missing required environment variables: ${missingVars.join(', ')}');
}

// Get configuration summary
final configSummary = EnvironmentConfig.getConfigSummary();
print('Configuration: $configSummary');
```

## Security Best Practices

1. **Never commit sensitive data** to version control
2. **Use different keys** for development, staging, and production
3. **Rotate keys regularly** for production environments
4. **Limit access** to environment variables to only necessary team members
5. **Monitor usage** of API keys and revoke if compromised
6. **Use environment-specific configurations** to prevent accidental production deployments

## Troubleshooting

### Common Issues

1. **"Environment variable not set" error**:
   - Ensure the variable is defined in your environment
   - Check that the variable name matches exactly (case-sensitive)
   - Verify the variable is being passed correctly to the Flutter app

2. **API calls failing**:
   - Verify API keys are valid and have the correct permissions
   - Check that the base URLs are correct for your environment
   - Ensure network connectivity and firewall settings

3. **Authentication issues**:
   - Verify OAuth client IDs are correct
   - Check redirect URIs match your application configuration
   - Ensure Firebase project ID is correct

### Debugging

Enable debug logging to see which environment variables are being loaded:

```dart
final configSummary = EnvironmentConfig.getConfigSummary();
print('Loaded configuration: $configSummary');
```

## Migration from Hardcoded Values

If you're migrating from hardcoded values, follow these steps:

1. **Identify hardcoded values** in your codebase
2. **Create environment variables** for each value
3. **Update the code** to use `String.fromEnvironment()` or the `EnvironmentConfig` class
4. **Test thoroughly** in each environment
5. **Update documentation** to reflect the new configuration approach

## Support

For questions about environment configuration:
- Check the [Flutter documentation](https://docs.flutter.dev/deployment/environment-variables)
- Review the [Firebase documentation](https://firebase.google.com/docs/functions/config-env)
- Contact the development team for project-specific guidance 