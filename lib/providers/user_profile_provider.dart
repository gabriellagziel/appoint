import 'package:appoint/models/user_profile.dart';
import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/user_profile_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProfileServiceProvider =
    Provider<UserProfileService>((ref) => UserProfileService());

final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(userProfileServiceProvider).watchProfile(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, final __) => const Stream.empty(),
  );
});

final FutureProviderFamily<UserProfile?, String> userProfileProvider =
    FutureProvider.family<UserProfile?, String>((ref, final uid) =>
        ref.read(userProfileServiceProvider).getProfile(uid));
