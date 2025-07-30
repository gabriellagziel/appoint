import 'package:appoint/l10n/app_localizations.dart';
import 'package:appoint/services/error_handling_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../firebase_test_helper.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  late ErrorHandlingService service;
  late MockAppLocalizations l10n;

  setUp(() {
    service = ErrorHandlingService();
    l10n = MockAppLocalizations();
    // Setup all expected getters
    when(() => l10n.authErrorUserNotFound).thenReturn('user-not-found');
    when(() => l10n.authErrorWrongPassword).thenReturn('wrong-password');
    when(() => l10n.authErrorInvalidEmail).thenReturn('invalid-email');
    when(() => l10n.authErrorUserDisabled).thenReturn('user-disabled');
    when(() => l10n.authErrorWeakPassword).thenReturn('weak-password');
    when(() => l10n.authErrorEmailAlreadyInUse)
        .thenReturn('email-already-in-use');
    when(() => l10n.authErrorTooManyRequests).thenReturn('too-many-requests');
    when(() => l10n.authErrorOperationNotAllowed)
        .thenReturn('operation-not-allowed');
    when(() => l10n.authErrorInvalidCredential)
        .thenReturn('invalid-credential');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('REDACTED_TOKEN');
    when(() => l10n.authErrorCredentialAlreadyInUse)
        .thenReturn('credential-already-in-use');
    when(() => l10n.authErrorNetworkRequestFailed)
        .thenReturn('network-request-failed');
    when(() => l10n.authErrorRequiresRecentLogin)
        .thenReturn('requires-recent-login');
    when(() => l10n.authErrorAppNotAuthorized).thenReturn('app-not-authorized');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-verification-code');
    when(() => l10n.authErrorInvalidVerificationId)
        .thenReturn('invalid-verification-id');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('missing-verification-code');
    when(() => l10n.authErrorMissingVerificationId)
        .thenReturn('missing-verification-id');
    when(() => l10n.authErrorInvalidPhoneNumber)
        .thenReturn('invalid-phone-number');
    when(() => l10n.authErrorMissingPhoneNumber)
        .thenReturn('missing-phone-number');
    when(() => l10n.authErrorQuotaExceeded).thenReturn('quota-exceeded');
    when(() => l10n.authErrorCodeExpired).thenReturn('code-expired');
    when(() => l10n.authErrorSessionExpired).thenReturn('session-expired');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('multi-factor-auth-required');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('multi-factor-info-not-found');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('missing-multi-factor-session');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-multi-factor-session');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('second-factor-already-in-use');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('REDACTED_TOKEN');
    when(() => l10n.authErrorUnsupportedFirstFactor)
        .thenReturn('unsupported-first-factor');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('email-change-needs-verification');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('phone-number-already-exists');
    when(() => l10n.authErrorInvalidPassword).thenReturn('invalid-password');
    when(() => l10n.authErrorInvalidIdToken).thenReturn('invalid-id-token');
    when(() => l10n.authErrorIdTokenExpired).thenReturn('id-token-expired');
    when(() => l10n.authErrorIdTokenRevoked).thenReturn('id-token-revoked');
    when(() => l10n.authErrorInternalError).thenReturn('internal-error');
    when(() => l10n.authErrorInvalidArgument).thenReturn('invalid-argument');
    when(() => l10n.authErrorInvalidClaims).thenReturn('invalid-claims');
    when(() => l10n.authErrorInvalidContinueUri)
        .thenReturn('invalid-continue-uri');
    when(() => l10n.authErrorInvalidCreationTime)
        .thenReturn('invalid-creation-time');
    when(() => l10n.authErrorInvalidDisabledField)
        .thenReturn('invalid-disabled-field');
    when(() => l10n.authErrorInvalidDisplayName)
        .thenReturn('invalid-display-name');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-dynamic-link-domain');
    when(() => l10n.authErrorInvalidEmailVerified)
        .thenReturn('invalid-email-verified');
    when(() => l10n.authErrorInvalidHashAlgorithm)
        .thenReturn('invalid-hash-algorithm');
    when(() => l10n.authErrorInvalidHashBlockSize)
        .thenReturn('invalid-hash-block-size');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-hash-derived-key-length');
    when(() => l10n.authErrorInvalidHashKey).thenReturn('invalid-hash-key');
    when(() => l10n.authErrorInvalidHashMemoryCost)
        .thenReturn('invalid-hash-memory-cost');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-hash-parallelization');
    when(() => l10n.authErrorInvalidHashRounds)
        .thenReturn('invalid-hash-rounds');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-hash-salt-separator');
    when(() => l10n.authErrorInvalidLastSignInTime)
        .thenReturn('invalid-last-sign-in-time');
    when(() => l10n.authErrorInvalidPageToken).thenReturn('invalid-page-token');
    when(() => l10n.authErrorInvalidProviderData)
        .thenReturn('invalid-provider-data');
    when(() => l10n.authErrorInvalidProviderId)
        .thenReturn('invalid-provider-id');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('invalid-session-cookie-duration');
    when(() => l10n.authErrorInvalidUid).thenReturn('invalid-uid');
    when(() => l10n.authErrorInvalidUserImport)
        .thenReturn('invalid-user-import');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('maximum-user-count-exceeded');
    when(() => l10n.authErrorMissingAndroidPkgName)
        .thenReturn('missing-android-pkg-name');
    when(() => l10n.authErrorMissingContinueUri)
        .thenReturn('missing-continue-uri');
    when(() => l10n.authErrorMissingHashAlgorithm)
        .thenReturn('missing-hash-algorithm');
    when(() => l10n.authErrorMissingIosBundleId)
        .thenReturn('missing-ios-bundle-id');
    when(() => l10n.authErrorMissingUid).thenReturn('missing-uid');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('missing-oauth-client-secret');
    when(() => l10n.authErrorProjectNotFound).thenReturn('project-not-found');
    when(() => l10n.authErrorReservedClaims).thenReturn('reserved-claims');
    when(() => l10n.authErrorSessionCookieExpired)
        .thenReturn('session-cookie-expired');
    when(() => l10n.authErrorSessionCookieRevoked)
        .thenReturn('session-cookie-revoked');
    when(() => l10n.authErrorUidAlreadyExists).thenReturn('uid-already-exists');
    when(() => l10n.REDACTED_TOKEN)
        .thenReturn('unauthorized-continue-uri');
    when(() => l10n.authErrorUnknown).thenReturn('unknown');
  });

  test('returns correct localized string for each Firebase Auth error code',
      () {
    final codes = <String, String>{
      'user-not-found': l10n.authErrorUserNotFound,
      'wrong-password': l10n.authErrorWrongPassword,
      'invalid-email': l10n.authErrorInvalidEmail,
      'user-disabled': l10n.authErrorUserDisabled,
      'weak-password': l10n.authErrorWeakPassword,
      'email-already-in-use': l10n.authErrorEmailAlreadyInUse,
      'too-many-requests': l10n.authErrorTooManyRequests,
      'operation-not-allowed': l10n.authErrorOperationNotAllowed,
      'invalid-credential': l10n.authErrorInvalidCredential,
      'REDACTED_TOKEN':
          l10n.REDACTED_TOKEN,
      'credential-already-in-use': l10n.authErrorCredentialAlreadyInUse,
      'network-request-failed': l10n.authErrorNetworkRequestFailed,
      'requires-recent-login': l10n.authErrorRequiresRecentLogin,
      'app-not-authorized': l10n.authErrorAppNotAuthorized,
      'invalid-verification-code': l10n.REDACTED_TOKEN,
      'invalid-verification-id': l10n.authErrorInvalidVerificationId,
      'missing-verification-code': l10n.REDACTED_TOKEN,
      'missing-verification-id': l10n.authErrorMissingVerificationId,
      'invalid-phone-number': l10n.authErrorInvalidPhoneNumber,
      'missing-phone-number': l10n.authErrorMissingPhoneNumber,
      'quota-exceeded': l10n.authErrorQuotaExceeded,
      'code-expired': l10n.authErrorCodeExpired,
      'session-expired': l10n.authErrorSessionExpired,
      'multi-factor-auth-required': l10n.REDACTED_TOKEN,
      'multi-factor-info-not-found': l10n.REDACTED_TOKEN,
      'missing-multi-factor-session': l10n.REDACTED_TOKEN,
      'invalid-multi-factor-session': l10n.REDACTED_TOKEN,
      'second-factor-already-in-use': l10n.REDACTED_TOKEN,
      'REDACTED_TOKEN':
          l10n.REDACTED_TOKEN,
      'unsupported-first-factor': l10n.authErrorUnsupportedFirstFactor,
      'email-change-needs-verification':
          l10n.REDACTED_TOKEN,
      'phone-number-already-exists': l10n.REDACTED_TOKEN,
      'invalid-password': l10n.authErrorInvalidPassword,
      'invalid-id-token': l10n.authErrorInvalidIdToken,
      'id-token-expired': l10n.authErrorIdTokenExpired,
      'id-token-revoked': l10n.authErrorIdTokenRevoked,
      'internal-error': l10n.authErrorInternalError,
      'invalid-argument': l10n.authErrorInvalidArgument,
      'invalid-claims': l10n.authErrorInvalidClaims,
      'invalid-continue-uri': l10n.authErrorInvalidContinueUri,
      'invalid-creation-time': l10n.authErrorInvalidCreationTime,
      'invalid-disabled-field': l10n.authErrorInvalidDisabledField,
      'invalid-display-name': l10n.authErrorInvalidDisplayName,
      'invalid-dynamic-link-domain': l10n.REDACTED_TOKEN,
      'invalid-email-verified': l10n.authErrorInvalidEmailVerified,
      'invalid-hash-algorithm': l10n.authErrorInvalidHashAlgorithm,
      'invalid-hash-block-size': l10n.authErrorInvalidHashBlockSize,
      'invalid-hash-derived-key-length':
          l10n.REDACTED_TOKEN,
      'invalid-hash-key': l10n.authErrorInvalidHashKey,
      'invalid-hash-memory-cost': l10n.authErrorInvalidHashMemoryCost,
      'invalid-hash-parallelization': l10n.REDACTED_TOKEN,
      'invalid-hash-rounds': l10n.authErrorInvalidHashRounds,
      'invalid-hash-salt-separator': l10n.REDACTED_TOKEN,
      'invalid-last-sign-in-time': l10n.authErrorInvalidLastSignInTime,
      'invalid-page-token': l10n.authErrorInvalidPageToken,
      'invalid-provider-data': l10n.authErrorInvalidProviderData,
      'invalid-provider-id': l10n.authErrorInvalidProviderId,
      'invalid-session-cookie-duration':
          l10n.REDACTED_TOKEN,
      'invalid-uid': l10n.authErrorInvalidUid,
      'invalid-user-import': l10n.authErrorInvalidUserImport,
      'maximum-user-count-exceeded': l10n.REDACTED_TOKEN,
      'missing-android-pkg-name': l10n.authErrorMissingAndroidPkgName,
      'missing-continue-uri': l10n.authErrorMissingContinueUri,
      'missing-hash-algorithm': l10n.authErrorMissingHashAlgorithm,
      'missing-ios-bundle-id': l10n.authErrorMissingIosBundleId,
      'missing-uid': l10n.authErrorMissingUid,
      'missing-oauth-client-secret': l10n.REDACTED_TOKEN,
      'project-not-found': l10n.authErrorProjectNotFound,
      'reserved-claims': l10n.authErrorReservedClaims,
      'session-cookie-expired': l10n.authErrorSessionCookieExpired,
      'session-cookie-revoked': l10n.authErrorSessionCookieRevoked,
      'uid-already-exists': l10n.authErrorUidAlreadyExists,
      'unauthorized-continue-uri': l10n.REDACTED_TOKEN,
    };

    codes.forEach((code, expected) {
      final e = FirebaseAuthException(code: code);
      final result = service.getLocalizedFirebaseAuthError(e, l10n);
      expect(result, expected, reason: 'Failed for code: $code');
    });
  });

  test('returns unknown for unmapped error code', () {
    final e = FirebaseAuthException(code: 'some-unknown-code');
    final result = service.getLocalizedFirebaseAuthError(e, l10n);
    expect(result, l10n.authErrorUnknown);
  });
}
