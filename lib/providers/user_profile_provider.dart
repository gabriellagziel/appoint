import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/user_profile.dart';
import 'package:appoint/services/user_profile_service.dart';
import 'package:appoint/providers/auth_provider.dart';

final userProfileServiceProvider =
    Provider<UserProfileService>((final ref) => UserProfileService());

final currentUserProfileProvider = StreamProvider<UserProfile?>((final ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (final user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(userProfileServiceProvider).watchProfile(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (final _, final __) => const Stream.empty(),
  );
});

final userProfileProvider =
    FutureProvider.family<UserProfile?, String>((final ref, final uid) {
  return ref.read(userProfileServiceProvider).getProfile(uid);
});
