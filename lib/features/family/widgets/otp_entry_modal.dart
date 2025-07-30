import 'package:appoint/providers/otp_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpEntryModal extends ConsumerStatefulWidget {
  const OtpEntryModal({
    required this.parentId,
    required this.childContact,
    super.key,
  });
  final String parentId;
  final String childContact;

  @override
  ConsumerState<OtpEntryModal> createState() => _OtpEntryModalState();
}

class _OtpEntryModalState extends ConsumerState<OtpEntryModal> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _onVerify() async {
    await ref
        .read(otpProvider.notifier)
        .verifyOtp(widget.childContact, _codeController.text.trim());
    if (mounted && ref.read(otpProvider) == OtpState.success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Child linked successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(otpProvider);

    return AlertDialog(
      title: const Text('Enter OTP'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(labelText: 'OTP Code'),
          ),
          if (state == OtpState.verifying) const CircularProgressIndicator(),
          if (state == OtpState.error)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Invalid code, please try again.',
                style: TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: state == OtpState.verifying
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: state == OtpState.verifying ? null : _onVerify,
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
