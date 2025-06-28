import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/referral_service.dart';

final referralServiceProvider =
    Provider<ReferralService>((ref) => ReferralService());

final referralCodeProvider = FutureProvider<String>((ref) {
  return ref.read(referralServiceProvider).generateReferralCode();
});
