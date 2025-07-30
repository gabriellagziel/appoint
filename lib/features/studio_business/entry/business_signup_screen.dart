import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSignupScreen extends ConsumerWidget {
  const BusinessSignupScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Business Signup')),
        body: const Center(
          child: Text('Business Signup Screen - Coming Soon'),
        ),
      );
}
