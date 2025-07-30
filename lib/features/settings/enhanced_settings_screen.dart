import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/theme_provider.dart';

final settingsProvider = StateProvider<Map<String, dynamic>>(
  (ref) => {
    'notifications': {
      'booking': true,
      'messages': true,
      'rewards': true,
      'system': false,
    },
    'privacy': {
      'profileVisibility': 'family',
      'locationSharing': false,
      'dataCollection': true,
    },
    'appearance': {
      'theme': 'system',
      'language': 'en',
      'fontSize': 'medium',
    },
    'subscription': {
      'plan': 'free',
      'autoRenew': false,
    },
  },
);

class EnhancedSettingsScreen extends ConsumerWidget {
  const EnhancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showHelp(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildProfileSection(context),
          _buildNotificationsSection(context, ref, settings),
          _buildPrivacySection(context, ref, settings),
          _buildAppearanceSection(context, ref, settings),
          _buildSubscriptionSection(context, ref, settings),
          _buildSupportSection(context),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) => Card(
        margin: const EdgeInsets.all(16),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.person, color: Colors.white, size: 30),
          ),
          title: const Text('John Doe'),
          subtitle: const Text('john.doe@example.com'),
          trailing: const Icon(Icons.edit),
          onTap: () => Navigator.pushNamed(context, '/profile/edit'),
        ),
      );

  Widget _buildNotificationsSection(
      BuildContext context, WidgetRef ref, Map<String, dynamic> settings) {
    final notifications = settings['notifications'] as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Notifications',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          SwitchListTile(
            title: const Text('Booking Notifications'),
            subtitle: const Text('Get notified about booking updates'),
            value: notifications['booking'] ?? true,
            onChanged: (value) =>
                _updateNotificationSetting(ref, 'booking', value),
          ),
          SwitchListTile(
            title: const Text('Message Notifications'),
            subtitle: const Text('Get notified about new messages'),
            value: notifications['messages'] ?? true,
            onChanged: (value) =>
                _updateNotificationSetting(ref, 'messages', value),
          ),
          SwitchListTile(
            title: const Text('Rewards Notifications'),
            subtitle: const Text('Get notified about points and rewards'),
            value: notifications['rewards'] ?? true,
            onChanged: (value) =>
                _updateNotificationSetting(ref, 'rewards', value),
          ),
          SwitchListTile(
            title: const Text('System Notifications'),
            subtitle:
                const Text('Get notified about app updates and maintenance'),
            value: notifications['system'] ?? false,
            onChanged: (value) =>
                _updateNotificationSetting(ref, 'system', value),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(
      BuildContext context, WidgetRef ref, Map<String, dynamic> settings) {
    final privacy = settings['privacy'] as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Privacy & Security',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            title: const Text('Profile Visibility'),
            subtitle: Text(_getVisibilityText(privacy['profileVisibility'])),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showVisibilityDialog(context, ref),
          ),
          SwitchListTile(
            title: const Text('Location Sharing'),
            subtitle: const Text('Allow location access for nearby services'),
            value: privacy['locationSharing'] ?? false,
            onChanged: (value) =>
                _updatePrivacySetting(ref, 'locationSharing', value),
          ),
          SwitchListTile(
            title: const Text('Data Collection'),
            subtitle: const Text('Help improve the app with anonymous data'),
            value: privacy['dataCollection'] ?? true,
            onChanged: (value) =>
                _updatePrivacySetting(ref, 'dataCollection', value),
          ),
          ListTile(
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showPrivacyPolicy(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection(
      BuildContext context, WidgetRef ref, Map<String, dynamic> settings) {
    final appearance = settings['appearance'] as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_getThemeText(appearance['theme'])),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showThemeDialog(context, ref),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Toggle light/dark theme'),
            value: ref.watch(themeModeProvider) == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeNotifierProvider.notifier).setMode(
                  value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_getLanguageText(appearance['language'])),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showLanguageDialog(context, ref),
          ),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Text(_getFontSizeText(appearance['fontSize'])),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showFontSizeDialog(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionSection(
      BuildContext context, WidgetRef ref, Map<String, dynamic> settings) {
    final subscription = settings['subscription'] as Map<String, dynamic>;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Subscription',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ListTile(
            title: const Text('Current Plan'),
            subtitle: Text(_getPlanText(subscription['plan'])),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, '/subscription'),
          ),
          SwitchListTile(
            title: const Text('Auto-Renew'),
            subtitle: const Text('Automatically renew your subscription'),
            value: subscription['autoRenew'] ?? false,
            onChanged: (value) =>
                _updateSubscriptionSetting(ref, 'autoRenew', value),
          ),
          ListTile(
            title: const Text('Billing History'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showBillingHistory(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportSection(BuildContext context) => Card(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Support',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Help Center'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showHelpCenter(context),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Contact Support'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _contactSupport(context),
            ),
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Report a Bug'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _reportBug(context),
            ),
            ListTile(
              leading: const Icon(Icons.feedback),
              title: const Text('Send Feedback'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _sendFeedback(context),
            ),
          ],
        ),
      );

  Widget _buildAboutSection(BuildContext context) => Card(
        margin: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'About',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('App Version'),
              subtitle: const Text('1.0.0'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAppInfo(context),
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showTermsOfService(context),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showPrivacyPolicy(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      );

  void _updateNotificationSetting(WidgetRef ref, String key, bool value) {
    final settings = ref.read(settingsProvider);
    final notifications = Map<String, dynamic>.from(settings['notifications']);
    notifications[key] = value;

    ref.read(settingsProvider.notifier).state = {
      ...settings,
      'notifications': notifications,
    };
  }

  void _updatePrivacySetting(WidgetRef ref, String key, value) {
    final settings = ref.read(settingsProvider);
    final privacy = Map<String, dynamic>.from(settings['privacy']);
    privacy[key] = value;

    ref.read(settingsProvider.notifier).state = {
      ...settings,
      'privacy': privacy,
    };
  }

  void _updateSubscriptionSetting(WidgetRef ref, String key, bool value) {
    final settings = ref.read(settingsProvider);
    final subscription = Map<String, dynamic>.from(settings['subscription']);
    subscription[key] = value;

    ref.read(settingsProvider.notifier).state = {
      ...settings,
      'subscription': subscription,
    };
  }

  String _getVisibilityText(String visibility) {
    switch (visibility) {
      case 'public':
        return 'Visible to everyone';
      case 'family':
        return 'Visible to family only';
      case 'private':
        return 'Visible to you only';
      default:
        return 'Visible to family only';
    }
  }

  String _getThemeText(String theme) {
    switch (theme) {
      case 'light':
        return 'Light';
      case 'dark':
        return 'Dark';
      case 'system':
        return 'System';
      default:
        return 'System';
    }
  }

  String _getLanguageText(String language) {
    switch (language) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      default:
        return 'English';
    }
  }

  String _getFontSizeText(String fontSize) {
    switch (fontSize) {
      case 'small':
        return 'Small';
      case 'medium':
        return 'Medium';
      case 'large':
        return 'Large';
      default:
        return 'Medium';
    }
  }

  String _getPlanText(String plan) {
    switch (plan) {
      case 'free':
        return 'Free Plan';
      case 'premium':
        return 'Premium Plan';
      case 'business':
        return 'Business Plan';
      default:
        return 'Free Plan';
    }
  }

  void _showVisibilityDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Profile Visibility'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('Public'),
              subtitle: const Text('Visible to everyone'),
              value: 'public',
              groupValue: 'family', // TODO: Get current value
              onChanged: (value) {
                Navigator.pop(context);
                _updatePrivacySetting(ref, 'profileVisibility', value);
              },
            ),
            RadioListTile<String>(
              title: const Text('Family Only'),
              subtitle: const Text('Visible to family members'),
              value: 'family',
              groupValue: 'family',
              onChanged: (value) {
                Navigator.pop(context);
                _updatePrivacySetting(ref, 'profileVisibility', value);
              },
            ),
            RadioListTile<String>(
              title: const Text('Private'),
              subtitle: const Text('Visible to you only'),
              value: 'private',
              groupValue: 'family',
              onChanged: (value) {
                Navigator.pop(context);
                _updatePrivacySetting(ref, 'profileVisibility', value);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement theme dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme selection coming soon!')),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement language dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selection coming soon!')),
    );
  }

  void _showFontSizeDialog(BuildContext context, WidgetRef ref) {
    // TODO: Implement font size dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Font size selection coming soon!')),
    );
  }

  void _showHelp(BuildContext context) {
    // TODO: Show help
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help coming soon!')),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    Navigator.pushNamed(context, '/privacy-policy');
  }

  void _showBillingHistory(BuildContext context) {
    // TODO: Show billing history
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Billing history coming soon!')),
    );
  }

  void _showHelpCenter(BuildContext context) {
    // TODO: Show help center
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Help center coming soon!')),
    );
  }

  void _contactSupport(BuildContext context) {
    // TODO: Contact support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contact support coming soon!')),
    );
  }

  void _reportBug(BuildContext context) {
    // TODO: Report bug
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bug reporting coming soon!')),
    );
  }

  void _sendFeedback(BuildContext context) {
    // TODO: Send feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Feedback coming soon!')),
    );
  }

  void _showAppInfo(BuildContext context) {
    // TODO: Show app info
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('App info coming soon!')),
    );
  }

  void _showTermsOfService(BuildContext context) {
    Navigator.pushNamed(context, '/terms-of-service');
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement sign out
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
