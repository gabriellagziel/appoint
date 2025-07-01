import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessOnboardingScreen extends ConsumerWidget {
  const BusinessOnboardingScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Onboarding')),
      body: const Center(
        child: Text('Business Onboarding Screen - Coming Soon'),
      ),
    );
  }
}
