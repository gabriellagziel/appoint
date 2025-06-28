import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/rewards_service.dart';
import 'auth_provider.dart';

final rewardsServiceProvider =
    Provider<RewardsService>((ref) => RewardsService());

final userPointsProvider = StreamProvider<int>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) {
        return const Stream.empty();
      }
      return ref.read(rewardsServiceProvider).watchPoints(user.uid);
    },
    loading: () => const Stream.empty(),
    error: (_, __) => const Stream.empty(),
  );
});
