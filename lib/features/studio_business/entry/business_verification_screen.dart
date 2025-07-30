import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessVerificationScreen extends ConsumerWidget {
  const BusinessVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Verification')),
        body: const Center(
          child: Text('Business Verification Screen - Coming Soon'),
        ),
      );
}
