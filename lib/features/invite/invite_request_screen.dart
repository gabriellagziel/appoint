import 'dart:core';

import 'package:appoint/models/contact.dart';
import 'package:appoint/providers/invite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InviteRequestScreen extends ConsumerStatefulWidget {
  const InviteRequestScreen({super.key});

  @override
  ConsumerState<InviteRequestScreen> createState() =>
      _InviteRequestScreenState();
}

class _InviteRequestScreenState extends ConsumerState<InviteRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _requiresInstallFallback = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appointmentId = ModalRoute.of(context)!.settings.arguments! as String;
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Contact')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Email (Optional)'),
              ),
              SwitchListTile(
                title: const Text('Requires Install Fallback'),
                value: _requiresInstallFallback,
                onChanged: (v) => setState(() => _requiresInstallFallback = v),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final contact = Contact(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      displayName: _nameController.text,
                      phoneNumber: _phoneController.text,
                      email: _emailController.text.isEmpty
                          ? null
                          : _emailController.text,
                    );
                    await ref.read(inviteServiceProvider).sendInvite(
                          appointmentId,
                          contact,
                          requiresInstallFallback: _requiresInstallFallback,
                        );
                    if (!mounted) return;
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
                child: const Text('Send Invite'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
