import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessWelcomeScreen extends ConsumerWidget {
  const BusinessWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Welcome')),
        body: const Center(
          child: Text('Business Welcome Screen - Coming Soon'),
        ),
      );
}
