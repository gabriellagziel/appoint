import 'package:appoint/providers/appointment_provider.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/theme/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
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
              data: (list) => Text('Appointments: ${list.length}'),
              loading: () => const CircularProgressIndicator(),
              error: (_, final __) =>
                  const Text('Error loading appointments'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/booking/request');
              },
              child: const Text('Book Appointment'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/invite/list');
              },
              child: const Text('My Invites'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/dashboard');
              },
              child: const Text('Dashboard'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.push('/profile');
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
  const _HomeDrawer();

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Drawer(
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
              context.push('/dashboard');
            },
          ),
          ListTile(
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              context.push('/profile');
            },
          ),
          FutureBuilder<bool>(
            future: FirebaseAuth.instance.currentUser
                    ?.getIdTokenResult(true)
                    .then((r) => r.claims?['admin'] == true) ??
                Future.value(false),
            builder: (context, final snapshot) {
              if (snapshot.data == true) {
                return ListTile(
                  title: const Text('Admin'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/admin/dashboard');
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
