import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _logAnalyticsEvent('edit_profile_view');
  }

  void _logAnalyticsEvent(String eventName) {
    try {
      // Only log analytics if Firebase is initialized
      if (Firebase.apps.isNotEmpty) {
        FirebaseAnalytics.instance.logEvent(name: eventName);
      }
    } catch (e) {
      // Ignore analytics errors
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Semantics(
              label: 'Full name',
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  label: 'Personal biography',
                  hint: 'Tell us about yourself',
                  child: TextFormField(
                    controller: _bioController,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(150),
                    ],
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(labelText: 'Bio'),
                  ),
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_bioController.text.length}/150',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Semantics(
              label: 'Location or city',
              child: TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _logAnalyticsEvent('profile_saved');
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'bio': _bioController.text,
                  'location': _locationController.text,
                });
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
