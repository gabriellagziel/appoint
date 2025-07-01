import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminMonetizationScreen extends ConsumerWidget {
  const AdminMonetizationScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monetization Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Monetization settings will be implemented here'),
      ),
    );
  }
}
