import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessCompletionScreen extends ConsumerWidget {
  const BusinessCompletionScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Completion')),
        body: const Center(
          child: Text('Business Completion Screen - Coming Soon'),
        ),
      );
}
