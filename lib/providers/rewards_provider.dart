import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/rewards_service.dart';
import 'package:appoint/providers/auth_provider.dart';

final rewardsServiceProvider =
    Provider<RewardsService>((final ref) => RewardsService());

final userPointsProvider = StreamProvider<int>((final ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (final user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(rewardsServiceProvider).watchPoints(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (final _, final __) => const Stream.empty(),
  );
});
