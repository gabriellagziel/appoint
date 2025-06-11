import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_user.dart';
import '../models/organization.dart';
import '../models/analytics.dart';
import '../services/admin_service.dart';

final adminServiceProvider = Provider<AdminService>((ref) => AdminService());

final allUsersProvider = FutureProvider<List<AdminUser>>((ref) {
  return ref.read(adminServiceProvider).fetchAllUsers();
});

final orgsProvider = FutureProvider<List<Organization>>((ref) {
  return ref.read(adminServiceProvider).fetchOrganizations();
});

final analyticsProvider = FutureProvider<Analytics>((ref) {
  return ref.read(adminServiceProvider).fetchAnalytics();
});
