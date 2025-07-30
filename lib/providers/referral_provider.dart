import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/referral_service.dart';

final referralServiceProvider = Provider<ReferralService>((ref) {
  return ReferralService();
});

final referralCodeProvider = FutureProvider<String>((ref) {
  return ref.read(referralServiceProvider).generateReferralCode();
});

final referralUsageProvider = StreamProvider<int>((ref) {
  return ref.read(referralServiceProvider).listenToReferralUsage();
});
