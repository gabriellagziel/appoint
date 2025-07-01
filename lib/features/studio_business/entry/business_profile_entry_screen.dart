import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessProfileEntryScreen extends ConsumerWidget {
  const BusinessProfileEntryScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Business Profile Entry Screen - Coming Soon'),
      ),
    );
  }
}
