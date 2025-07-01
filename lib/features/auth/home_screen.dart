import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/providers/appointment_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appoint/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final appointments = ref.watch(appointmentsStreamProvider);
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text('Home')),
      drawer: const _HomeDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome'),
            appointments.when(
              data: (final list) => Text('Appointments: ${list.length}'),
              loading: () => const CircularProgressIndicator(),
              error: (final _, final __) => const Text('Error loading appointments'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/booking/request');
              },
              child: const Text('Book Appointment'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/invite/list');
              },
              child: const Text('My Invites'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/dashboard');
              },
              child: const Text('Dashboard'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: const Text('My Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await ref.read(authServiceProvider).signOut();
                // Trigger provider refresh and ignore the value.
                // ignore: unused_result
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

class _HomeDrawer extends ConsumerWidget {
  const _HomeDrawer({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(child: Text('Menu')),
          ListTile(
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard');
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile');
            },
          ),
          FutureBuilder<bool>(
            future: FirebaseAuth.instance.currentUser
                    ?.getIdTokenResult(true)
                    .then((final r) => r.claims?['admin'] == true) ??
                Future.value(false),
            builder: (final context, final snapshot) {
              if (snapshot.data == true) {
                return ListTile(
                  title: const Text('Admin'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/admin/dashboard');
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          ListTile(
            title: const Text('Sign Out'),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authServiceProvider).signOut();
              // Trigger provider refresh and ignore the value.
              // ignore: unused_result
              ref.refresh(authStateProvider);
            },
          ),
        ],
      ),
    );
  }
}
