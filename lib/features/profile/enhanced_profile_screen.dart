import 'package:appoint/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final userProfileProvider = StateProvider<UserProfile>((ref) => const UserProfile(
  id: 'user_123',
  name: 'John Doe',
  email: 'john.doe@example.com',
  phone: '+1 (555) 123-4567',
  avatar: null,
  userType: UserType.family,
  familyId: 'family_456',
  preferences: UserPreferences(
    notifications: true,
    locationSharing: false,
    language: 'en',
    theme: 'system',
  ),
  stats: UserStats(
    totalBookings: 25,
    totalPoints: 1250,
    memberSince: DateTime(2023, 1, 15),
  ),
));

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.avatar,
    required this.userType,
    this.familyId,
    required this.preferences,
    required this.stats,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String? avatar;
  final UserType userType;
  final String? familyId;
  final UserPreferences preferences;
  final UserStats stats;
}

class UserPreferences {
  const UserPreferences({
    required this.notifications,
    required this.locationSharing,
    required this.language,
    required this.theme,
  });

  final bool notifications;
  final bool locationSharing;
  final String language;
  final String theme;
}

class UserStats {
  const UserStats({
    required this.totalBookings,
    required this.totalPoints,
    required this.memberSince,
  });

  final int totalBookings;
  final int totalPoints;
  final DateTime memberSince;
}

enum UserType {
  family,
  business,
  admin,
}

class EnhancedProfileScreen extends ConsumerWidget {
  const EnhancedProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _editProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, profile),
            _buildStatsSection(context, profile.stats),
            _buildQuickActions(context),
            _buildFamilySection(context, profile),
            _buildPreferencesSection(context, ref, profile.preferences),
            _buildAccountSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserProfile profile) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Theme.of(context).primaryColor,
              backgroundImage: profile.avatar != null ? NetworkImage(profile.avatar!) : null,
              child: profile.avatar == null
                  ? Text(
                      profile.name.split(' ').map((n) => n[0]).join(''),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              profile.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              profile.email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _getUserTypeColor(profile.userType),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _getUserTypeText(profile.userType),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, UserStats stats) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Stats',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.calendar_today,
                    'Total Bookings',
                    stats.totalBookings.toString(),
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.stars,
                    'Points Earned',
                    stats.totalPoints.toString(),
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    context,
                    Icons.person_add,
                    'Member Since',
                    '${stats.memberSince.month}/${stats.memberSince.year}',
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold),
            ),
          ),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            childAspectRatio: 2.5,
            children: [
              _buildActionTile(context, Icons.search, 'Search Services', () => context.push('/search')),
              _buildActionTile(context, Icons.calendar_today, 'My Calendar', () => context.push('/calendar')),
              _buildActionTile(context, Icons.chat, 'Messages', () => context.push('/messages')),
              _buildActionTile(context, Icons.stars, 'Rewards', () => context.push('/rewards')),
              _buildActionTile(context, Icons.payment, 'Subscriptions', () => context.push('/subscription')),
              _buildActionTile(context, Icons.analytics, 'Analytics', () => context.push('/analytics')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).primaryColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFamilySection(BuildContext context, UserProfile profile) {
    if (profile.familyId == null) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.family_restroom, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Family',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/family'),
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Doe Family',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '4 members',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildPreferencesSection(BuildContext context, WidgetRef ref, UserPreferences preferences) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold),
            ),
          ),
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Receive push notifications'),
            value: preferences.notifications,
            onChanged: (value) => _updatePreference(ref, 'notifications', value),
          ),
          SwitchListTile(
            title: const Text('Location Sharing'),
            subtitle: const Text('Share location for nearby services'),
            value: preferences.locationSharing,
            onChanged: (value) => _updatePreference(ref, 'locationSharing', value),
          ),
          ListTile(
            title: const Text('Language'),
            subtitle: Text(_getLanguageText(preferences.language)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _changeLanguage(context, ref),
          ),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(_getThemeText(preferences.theme)),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _changeTheme(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Security'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showSecuritySettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.backup),
            title: const Text('Backup & Restore'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showBackupSettings(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete Account'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }

  Color _getUserTypeColor(UserType userType) {
    switch (userType) {
      case UserType.family:
        return Colors.blue;
      case UserType.business:
        return Colors.green;
      case UserType.admin:
        return Colors.purple;
    }
  }

  String _getUserTypeText(UserType userType) {
    switch (userType) {
      case UserType.family:
        return 'Family Member';
      case UserType.business:
        return 'Business Owner';
      case UserType.admin:
        return 'System Admin';
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

  void _updatePreference(WidgetRef ref, String key, dynamic value) {
    final profile = ref.read(userProfileProvider);
    final preferences = profile.preferences;
    
    UserPreferences newPreferences;
    switch (key) {
      case 'notifications':
        newPreferences = UserPreferences(
          notifications: value,
          locationSharing: preferences.locationSharing,
          language: preferences.language,
          theme: preferences.theme,
        );
        break;
      case 'locationSharing':
        newPreferences = UserPreferences(
          notifications: preferences.notifications,
          locationSharing: value,
          language: preferences.language,
          theme: preferences.theme,
        );
        break;
      default:
        return;
    }

    ref.read(userProfileProvider.notifier).state = UserProfile(
      id: profile.id,
      name: profile.name,
      email: profile.email,
      phone: profile.phone,
      avatar: profile.avatar,
      userType: profile.userType,
      familyId: profile.familyId,
      preferences: newPreferences,
      stats: profile.stats,
    );
  }

  void _editProfile(BuildContext context) {
    // TODO: Navigate to edit profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit profile coming soon!')),
    );
  }

  void _changeLanguage(BuildContext context, WidgetRef ref) {
    // TODO: Show language selection dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Language selection coming soon!')),
    );
  }

  void _changeTheme(BuildContext context, WidgetRef ref) {
    // TODO: Show theme selection dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Theme selection coming soon!')),
    );
  }

  void _showSecuritySettings(BuildContext context) {
    // TODO: Show security settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security settings coming soon!')),
    );
  }

  void _showBackupSettings(BuildContext context) {
    // TODO: Show backup settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Backup settings coming soon!')),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 