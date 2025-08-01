import 'package:appoint/constants/app_branding.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLoginForm() => Column(
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
          if (_isLoading)
            const CircularProgressIndicator()
          else
            ElevatedButton(
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
                } finally {
                  if (mounted) {
                    setState(() => _isLoading = false);
                  }
                }
              },
              child: const Text('Sign In'),
            ),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App logo and branding
                  const AppLogo(size: 100),
                  const SizedBox(height: 32),
                  Text(
                    'Welcome Back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    AppBranding.fullSlogan,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Login form
                  _buildLoginForm(),

                  const SizedBox(height: 24),

                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Forgot your password? '),
                      TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
