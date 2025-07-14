import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: const Center(
        child: Text('Onboarding Screen'),
      ),
    );
  }
}

class EnhancedOnboardingScreen extends StatelessWidget {
  const EnhancedOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enhanced Onboarding')),
      body: const Center(
        child: Text('Enhanced Onboarding Screen'),
      ),
    );
  }
}
