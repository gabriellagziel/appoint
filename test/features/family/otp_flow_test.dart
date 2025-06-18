import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../test_setup.dart';
import 'package:appoint/services/family_service.dart';
import 'package:appoint/providers/otp_provider.dart';
import 'package:appoint/providers/family_provider.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:appoint/services/whatsapp_share_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await registerFirebaseMock();
  });

  group('OTP Flow', () {
    late MockFamilyService mockService;
    late ProviderContainer container;
    late FamilyService familyService;
    late MockFirebaseFirestore mockFirestore;
    late MockFirebaseAnalytics mockAnalytics;
    late MockWhatsAppShareService mockWhatsAppShareService;
    late MockFirebaseAuth mockAuth;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockAuth = MockFirebaseAuth();
      mockAnalytics = MockFirebaseAnalytics();
      mockWhatsAppShareService = MockWhatsAppShareService();
      when(mockFirestore.collection('appointments'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('users'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('admin_broadcasts'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('share_analytics'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('group_recognition'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('invites'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('payments'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('organizations'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('analytics'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('family_links'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('family_analytics'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('privacy_requests'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('calendar_events'))
          .thenReturn(MockCollectionReference());
      when(mockFirestore.collection('callRequests'))
          .thenReturn(MockCollectionReference());
      familyService = FamilyService(firestore: mockFirestore, auth: mockAuth);
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
  Future<void> sendOtp(String parentContact, String childId) async {
    sendCalled = true;
    await Future.delayed(const Duration(milliseconds: 10));
    if (parentContact == 'fail') throw Exception('Send failed');
  }

  @override
  Future<bool> verifyOtp(String parentContact, String code) async {
    verifyCalled = true;
    await Future.delayed(const Duration(milliseconds: 10));
    if (code == '123456') return true;
    return false;
  }
}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockFirebaseAnalytics extends Mock implements FirebaseAnalytics {}

class MockWhatsAppShareService extends Mock implements WhatsAppShareService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}
