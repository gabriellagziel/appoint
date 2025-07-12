import 'package:appoint/models/user_role.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

userRoleProvider = Provider<UserRole>((final ref) {
  // TODO(username): Replace with Firebase user role from authentication service
  return UserRole.business;
});
