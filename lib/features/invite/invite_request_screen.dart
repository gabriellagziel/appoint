import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/contact.dart';
import '../../providers/invite_provider.dart';

class InviteRequestScreen extends ConsumerStatefulWidget {
  const InviteRequestScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<InviteRequestScreen> createState() => _InviteRequestScreenState();
}

class _InviteRequestScreenState extends ConsumerState<InviteRequestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _requiresInstallFallback = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String appointmentId =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Send Invite')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            SwitchListTile(
              title: const Text('Requires Install Fallback'),
              value: _requiresInstallFallback,
              onChanged: (v) => setState(() => _requiresInstallFallback = v),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final contact = Contact(
                  id: _phoneController.text,
                  displayName: _nameController.text,
                  phone: _phoneController.text,
                );
                await ref
                    .read(inviteServiceProvider)
                    .sendInvite(appointmentId, contact,
                        requiresInstallFallback: _requiresInstallFallback);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Send Invite'),
            )
          ],
        ),
      ),
    );
  }
}
