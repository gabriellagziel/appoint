import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/minor_parent_request.dart';

class MinorParentNotifier extends StateNotifier<MinorParentRequest?> {
  MinorParentNotifier() : super(null);

  void sendOtp(String minorId, String phone) {
    final otp = (Random().nextInt(900000) + 100000).toString();
    state = MinorParentRequest(
      minorId: minorId,
      parentPhoneNumber: phone,
      otpCode: otp,
      isVerified: false,
    );
    // In a real app, send the OTP via SMS here
  }

  bool verifyOtp(String code) {
    if (state == null) return false;
    if (state!.otpCode == code) {
      state = state!.copyWith(isVerified: true);
      return true;
    }
    return false;
  }
}

final minorParentProvider =
    StateNotifierProvider<MinorParentNotifier, MinorParentRequest?>(
  (ref) => MinorParentNotifier(),
);
