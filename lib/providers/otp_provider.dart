import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/services/family_service.dart';
import 'package:appoint/providers/family_provider.dart';

// OTP flow states
enum OtpState { idle, sending, codeSent, verifying, success, error }

class OtpNotifier extends StateNotifier<OtpState> {
  final FamilyService _familyService;

  OtpNotifier(this._familyService) : super(OtpState.idle);

  Future<void> sendOtp(final String childContact, final String parentId) async {
    state = OtpState.sending;
    try {
      await _familyService.sendOtp(childContact, parentId);
      state = OtpState.codeSent;
    } catch (_) {
      state = OtpState.error;
    }
  }

  Future<void> verifyOtp(final String childContact, final String code) async {
    state = OtpState.verifying;
    try {
      final result = await _familyService.verifyOtp(childContact, code);
      if (result == true) {
        state = OtpState.success;
      } else {
        state = OtpState.error;
      }
    } catch (_) {
      state = OtpState.error;
    }
  }
}

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>((final ref) {
  final familyService = ref.watch(familyServiceProvider);
  return OtpNotifier(familyService);
});
