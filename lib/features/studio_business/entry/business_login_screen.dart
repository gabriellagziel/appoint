import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessLoginScreen extends ConsumerWidget {
  const BusinessLoginScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Login')),
      body: const Center(
        child: Text('Business Login Screen - Coming Soon'),
      ),
    );
  }
}
