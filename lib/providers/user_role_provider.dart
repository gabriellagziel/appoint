import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/user_role.dart';

final userRoleProvider = Provider<UserRole>((final ref) {
  // TODO: Replace with Firebase user role from authentication service
  return UserRole.business;
});
