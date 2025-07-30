import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/rewards_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    error: (_, final __) => const Stream.empty(),
  );
});
