import 'package:appoint/providers/auth_provider.dart';
import 'package:appoint/services/referral_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final referralServiceProvider =
    Provider<ReferralService>((ref) => ReferralService());

referralCodeProvider = FutureProvider<String>((final ref) async {
  user = ref.read(authProvider).currentUser;
  if (user == null) {
    throw Exception('User not logged in');
  }
  return ref.read(referralServiceProvider).generateReferralCode(user.uid);
});
