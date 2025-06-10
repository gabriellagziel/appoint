import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                ref.refresh(authStateProvider);
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
