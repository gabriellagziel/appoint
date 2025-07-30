import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSetupScreen extends ConsumerWidget {
  const BusinessSetupScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Setup')),
        body: const Center(
          child: Text('Business Setup Screen - Coming Soon'),
        ),
      );
}
