import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/reward_tier.dart';
import '../services/rewards_service.dart';

final rewardsServiceProvider =
    Provider<RewardsService>((ref) => RewardsService());

final rewardTiersProvider = Provider<List<RewardTier>>((ref) {
  return ref.read(rewardsServiceProvider).rewardTiers;
});

final userPointsProvider = StreamProvider<int>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    return const Stream<int>.value(0);
  }
  return ref.read(rewardsServiceProvider).watchPoints(uid);
});
