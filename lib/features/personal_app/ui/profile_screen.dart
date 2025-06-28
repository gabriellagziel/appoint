import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// TODO: Implement according to spec §2.1

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = 'Username';
  String _bio = 'Bio';
  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            Text(_name),
            const SizedBox(height: 8),
            Text(_bio),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                FirebaseAnalytics.instance.logEvent(name: 'edit_profile_tap');
                final result = await Navigator.pushNamed(context, '/profile/edit');
                if (result is Map) {
                  setState(() {
                    _name = result['name'] as String? ?? _name;
                    _bio = result['bio'] as String? ?? _bio;
                    _location = result['location'] as String? ?? _location;
                  });
                }
              },
              child: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
