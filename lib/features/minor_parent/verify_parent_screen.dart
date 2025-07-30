import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/minor_parent_provider.dart';

class VerifyParentScreen extends ConsumerStatefulWidget {
  const VerifyParentScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<VerifyParentScreen> createState() => _VerifyParentScreenState();
}

class _VerifyParentScreenState extends ConsumerState<VerifyParentScreen> {
  final _otpController = TextEditingController();
  bool _error = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = ref.watch(minorParentProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Parent')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('OTP sent to ${request?.parentPhoneNumber ?? ''}'),
            TextField(
              controller: _otpController,
              decoration: InputDecoration(
                labelText: 'OTP Code',
                errorText: _error ? 'Invalid code' : null,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final success = ref
                    .read(minorParentProvider.notifier)
                    .verifyOtp(_otpController.text);
                if (success) {
                  Navigator.popUntil(context, ModalRoute.withName('/booking'));
                } else {
                  setState(() => _error = true);
                }
              },
              child: const Text('Verify'),
            )
          ],
        ),
      ),
    );
  }
}
