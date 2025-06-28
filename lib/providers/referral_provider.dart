import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/referral_service.dart';
import 'auth_provider.dart';

final referralServiceProvider =
    Provider<ReferralService>((ref) => ReferralService());

final referralCodeProvider = FutureProvider<String>((ref) async {
  final user = ref.read(authProvider).currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }
  return ref.read(referralServiceProvider).generateReferralCode(user.uid);
});
