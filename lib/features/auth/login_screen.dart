import 'package:appoint/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Semantics(
              label: 'Email address',
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ),
            Semantics(
              label: 'Password',
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 16),
            if (_isLoading) const CircularProgressIndicator() else ElevatedButton(
                    onPressed: () async {
                      setState(() => _isLoading = true);
                      try {
                        await ref.read(authServiceProvider).signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                        if (!mounted) return;
                        // TODO(username): Implement notification token saving
                        // uid = ref.read(authProvider).currentUser?.uid;
                        // if (uid != null) {
                        //   ref
                        //       .read(notificationServiceProvider)
                        //       .saveTokenForUser(uid);
                        // }
                        // TODO(username): Implement auth state refresh
                        // if (mounted) {
                        //   ref.refresh(authStateProvider);
                        // }
                      } catch (e) {
                        if (!mounted) return;
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Login failed: $e')),
                        );
                        if (mounted) {
                          setState(() => _isLoading = false);
                        }
                      }
                    },
                    child: const Text('Sign In'),
                  ),
          ],
        ),
      ),
    );
}
