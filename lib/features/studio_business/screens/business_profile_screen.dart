import 'package:appoint/features/studio_business/providers/business_profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessProfileScreen extends ConsumerWidget {
  const BusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    profile = ref.watch(studioBusinessProfileProvider);
    notifier = ref.read(studioBusinessProfileProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Business Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: profile == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  TextFormField(
                    initialValue: profile.name,
                    decoration:
                        const InputDecoration(labelText: 'Business Name'),
                    onChanged: (value) =>
                        notifier.updateField(name: value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: profile.description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (value) =>
                        notifier.updateField(description: value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: profile.phone,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) =>
                        notifier.updateField(phone: value),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                    onPressed: () async {
                      await notifier.save();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Changes saved successfully!'),),
                        );
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
