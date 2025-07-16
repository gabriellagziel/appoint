import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvitationModal extends ConsumerStatefulWidget {
  const InvitationModal({super.key});

  @override
  ConsumerState<InvitationModal> createState() => _InvitationModalState();
}

class _InvitationModalState extends ConsumerState<InvitationModal> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendInvitation() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final familyService = ref.read(familyServiceProvider);
      final authState = await ref.read(authStateProvider.future);

      if (authState == null) {
        throw Exception('User not authenticated');
      }

      await familyService.inviteChild(
          authState.uid, _emailController.text.trim(),);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invitation sent successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send invitation: $e')),
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
      title: const Text('Invite Child'),
      content: TextField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Child Email',
          hintText: "Enter child's email address",
        ),
        keyboardType: TextInputType.emailAddress,
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _isLoading ? null : _sendInvitation,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Send'),
        ),
      ],
    );
}
