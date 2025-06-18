import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/admin_user.dart';
import '../models/organization.dart';
import '../models/analytics.dart';
import '../services/admin_service.dart';

final adminServiceProvider = Provider<AdminService>((ref) => AdminService());

// Admin role provider that checks Firebase Auth custom claims
final isAdminProvider = FutureProvider<bool>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  try {
    final tokenResult = await user.getIdTokenResult(true);
    return tokenResult.claims?['admin'] == true;
  } catch (e) {
    return false;
  }
});

final allUsersProvider = FutureProvider<List<AdminUser>>((ref) {
  return ref.read(adminServiceProvider).fetchAllUsers();
});

final orgsProvider = FutureProvider<List<Organization>>((ref) {
  return ref.read(adminServiceProvider).fetchOrganizations();
});

final analyticsProvider = FutureProvider<Analytics>((ref) {
  return ref.read(adminServiceProvider).fetchAnalytics();
});
