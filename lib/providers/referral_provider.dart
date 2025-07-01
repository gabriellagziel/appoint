import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/referral_service.dart';
import 'package:appoint/providers/auth_provider.dart';

final referralServiceProvider =
    Provider<ReferralService>((final ref) => ReferralService());

final referralCodeProvider = FutureProvider<String>((final ref) async {
  final user = ref.read(authProvider).currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }
  return ref.read(referralServiceProvider).generateReferralCode(user.uid);
});
