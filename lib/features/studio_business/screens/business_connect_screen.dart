import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessConnectScreen extends ConsumerStatefulWidget {
  const BusinessConnectScreen({super.key});

  @override
  ConsumerState<BusinessConnectScreen> createState() =>
      _BusinessConnectScreenState();
}

class _BusinessConnectScreenState extends ConsumerState<BusinessConnectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isConnecting = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Activate Business Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your upgrade code to activate your business profile:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Upgrade Code',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., UPGRADE_123456',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your upgrade code';
                  }
                  if (!value.startsWith('UPGRADE_')) {
                    return 'Invalid upgrade code format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isConnecting ? null : _connectBusiness,
                  child: _isConnecting
                      ? const CircularProgressIndicator()
                      : const Text('Activate Business Profile'),
                ),
              ),
              const SizedBox(height: 16),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What you get with Business Profile:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold,),
                      ),
                      SizedBox(height: 8),
                      Text('• Unlimited bookings per week'),
                      Text('• CRM dashboard with analytics'),
                      Text('• Phone-based booking system'),
                      Text('• Staff management tools'),
                      Text('• Advanced reporting'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _connectBusiness() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isConnecting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');

      final upgradeCode = _codeController.text.trim();

      // Validate the upgrade code (in a real app, this would check against a database)
      if (!_isValidUpgradeCode(upgradeCode)) {
        throw Exception('Invalid upgrade code');
      }

      // Update user's business mode
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'businessMode': true,
        'upgradeCode': upgradeCode,
        'businessActivatedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Business profile activated successfully!'),),
        );
        Navigator.pushReplacementNamed(context, '/business/dashboard');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
      }
    }
  }

  bool _isValidUpgradeCode(String code) {
    // Simple validation - in a real app, this would check against a database
    return code.startsWith('UPGRADE_') && code.length >= 10;
  }
}
