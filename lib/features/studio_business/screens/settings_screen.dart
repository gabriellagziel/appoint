import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _autoConfirmBookings = false;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('businessSettings')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _notificationsEnabled = data['notificationsEnabled'] ?? true;
          _autoConfirmBookings = data['autoConfirmBookings'] ?? false;
          _emailNotifications = data['emailNotifications'] ?? true;
          _smsNotifications = data['smsNotifications'] ?? false;
        });
      }
    } catch (e) {
      // Removed debug print: print('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('businessSettings')
          .doc(user.uid)
          .set({
        'notificationsEnabled': _notificationsEnabled,
        'autoConfirmBookings': _autoConfirmBookings,
        'emailNotifications': _emailNotifications,
        'smsNotifications': _smsNotifications,
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e')),
        );
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Notification Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive push notifications for new bookings'),
            value: _notificationsEnabled,
            onChanged: (final value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Email Notifications'),
            subtitle: const Text('Receive booking notifications via email'),
            value: _emailNotifications,
            onChanged: (final value) {
              setState(() {
                _emailNotifications = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('SMS Notifications'),
            subtitle: const Text('Receive booking notifications via SMS'),
            value: _smsNotifications,
            onChanged: (final value) {
              setState(() {
                _smsNotifications = value;
              });
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Booking Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Auto-Confirm Bookings'),
            subtitle: const Text('Automatically confirm new booking requests'),
            value: _autoConfirmBookings,
            onChanged: (final value) {
              setState(() {
                _autoConfirmBookings = value;
              });
            },
          ),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            'Account Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Business Profile'),
            subtitle: const Text('Update your business information'),
            onTap: () {
              Navigator.pushNamed(context, '/business/profile');
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy Settings'),
            subtitle: const Text('Manage your privacy preferences'),
            onTap: () {
              // TODO: Implement this featurent privacy settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            subtitle: const Text('Get help with your account'),
            onTap: () {
              // TODO: Implement this featurent help & support
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('App version and information'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'APP-OINT Business',
                applicationVersion: '1.0.0',
                applicationIcon: const FlutterLogo(size: 64),
                children: const [
                  Text(
                      'Business management app for studios and service providers.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
