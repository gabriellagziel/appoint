import 'package:appoint/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

import '../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('UserProfile', () {
    test('toJson/fromJson round trip', () {
      const profile = UserProfile(
        id: 'u1',
        name: 'John Doe',
        email: 'test@example.com',
        phone: '+1234567890',
        photoUrl: 'https://example.com/photo.jpg',
        isAdminFreeAccess: false,
      );

      final json = profile.toJson();
      final copy = UserProfile.fromJson(json);

      expect(copy.id, profile.id);
      expect(copy.name, profile.name);
      expect(copy.email, profile.email);
      expect(copy.phone, profile.phone);
      expect(copy.photoUrl, profile.photoUrl);
      expect(copy.isAdminFreeAccess, profile.isAdminFreeAccess);
    });

    test('should handle null optional fields', () {
      const profile = UserProfile(id: 'u2', name: 'Jane Doe');

      expect(profile.email, isNull);
      expect(profile.phone, isNull);
      expect(profile.photoUrl, isNull);
      expect(profile.isAdminFreeAccess, isNull);
    });
  });
}
