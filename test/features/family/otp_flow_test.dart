import 'package:appoint/providers/family_provider.dart';
import 'package:appoint/providers/otp_provider.dart';
import 'package:appoint/services/family_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/firebase_mocks.dart';
import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
    setupFirebaseMocks();
  });

  group('OTP Flow', () {
    late MockFamilyService mockService;
    late ProviderContainer container;
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockService = MockFamilyService();
      container = ProviderContainer(
        overrides: [
          familyServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    test('sendOtp success', () async {
      final otpNotifier = container.read(otpProvider.notifier);
      await otpNotifier.sendOtp('test@email.com', 'parentId');
      expect(mockService.sendCalled, isTrue);
      expect(container.read(otpProvider), OtpState.codeSent);
    });

    test('sendOtp failure', () async {
      final otpNotifier = container.read(otpProvider.notifier);
      await otpNotifier.sendOtp('fail', 'parentId');
      expect(mockService.sendCalled, isTrue);
      expect(container.read(otpProvider), OtpState.error);
    });

    test('verifyOtp success', () async {
      final otpNotifier = container.read(otpProvider.notifier);
      await otpNotifier.verifyOtp('test@email.com', '123456');
      expect(mockService.verifyCalled, isTrue);
      expect(container.read(otpProvider), OtpState.success);
    });

    test('verifyOtp failure', () async {
      final otpNotifier = container.read(otpProvider.notifier);
      await otpNotifier.verifyOtp('test@email.com', '000000');
      expect(mockService.verifyCalled, isTrue);
      expect(container.read(otpProvider), OtpState.error);
    });

    test('initial state is idle', () {
      expect(container.read(otpProvider), OtpState.idle);
    });
  });
}

class MockFamilyService extends FamilyService {
  bool sendCalled = false;
  bool verifyCalled = false;

  @override
  Future<void> sendOtp(String parentContact, final String childId) async {
    sendCalled = true;
    await Future.delayed(const Duration(milliseconds: 10));
    if (parentContact == 'fail') throw Exception('Send failed');
  }

  @override
  Future<bool> verifyOtp(String parentContact, final String code) async {
    verifyCalled = true;
    await Future.delayed(const Duration(milliseconds: 10));
    if (code == '123456') return true;
    return false;
  }
}
