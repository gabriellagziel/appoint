import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_role.dart';

final userRoleProvider = Provider<UserRole>((ref) {
  // TEMP: Hardcoded for demo — later replace with Firebase user role
  return UserRole.business;
});
