import 'package:appoint/features/family/widgets/otp_entry_modal.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/family_provider.dart';
// import 'package:appoint/providers/otp_provider.dart'; // Unused
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InviteChildScreen extends ConsumerStatefulWidget {
  const InviteChildScreen({super.key});

  @override
  ConsumerState<InviteChildScreen> createState() => _InviteChildScreenState();
}

class _InviteChildScreenState extends ConsumerState<InviteChildScreen> {
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _onSendInvite() async {
    final authState = ref.read(authStateProvider);
    final user = authState.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );
    final parentId = user?.uid;
    final contact = _contactController.text.trim();
    if (contact.isEmpty || parentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email or phone')),
      );
      return;
    }
    // 1) send invite
    await ref.read(familyServiceProvider).inviteChild(parentId, contact);
    // 2) send OTP
    await ref.read(otpProvider.notifier).sendOtp(contact, parentId);
    // 3) open the OTP modal
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) =>
            OtpEntryModal(parentId: parentId, childContact: contact),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Invite Child')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _contactController,
                decoration:
                    const InputDecoration(labelText: 'Child Email or Phone'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _onSendInvite,
                child: const Text('Send Invite'),
              ),
            ],
          ),
        ),
      );
}
