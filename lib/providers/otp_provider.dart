import 'package:appoint/providers/family_provider.dart';
import 'package:appoint/services/family_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// OTP flow states
enum OtpState { idle, sending, codeSent, verifying, success, error }

class OtpNotifier extends StateNotifier<OtpState> {
  OtpNotifier(this._familyService) : super(OtpState.idle);
  final FamilyService _familyService;

  Future<void> sendOtp(String childContact, final String parentId) async {
    state = OtpState.sending;
    try {
      await _familyService.sendOtp(childContact, parentId);
      state = OtpState.codeSent;
    } catch (e) {
      state = OtpState.error;
    }
  }

  Future<void> verifyOtp(String childContact, final String code) async {
    state = OtpState.verifying;
    try {
      final result = await _familyService.verifyOtp(childContact, code);
      if (result == true) {
        state = OtpState.success;
      } else {
        state = OtpState.error;
      }
    } catch (e) {
      state = OtpState.error;
    }
  }
}

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>((ref) {
  final familyService = ref.watch(familyServiceProvider);
  return OtpNotifier(familyService);
});
