import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/user_profile.dart';
import '../test_setup.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFirebaseMock();
  });

  group('UserProfile Model', () {
    test('should correctly create a user profile', () {
      final user = UserProfile(
        uid: '123',
        displayName: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.uid, '123');
      expect(user.displayName, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
    });

    test('should be able to convert to JSON and back', () {
      final user = UserProfile(
        uid: '123',
        displayName: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

      final json = user.toJson();
      final newUser = UserProfile.fromJson(json);

      expect(newUser.uid, user.uid);
      expect(newUser.displayName, user.displayName);
      expect(newUser.email, user.email);
      expect(newUser.photoUrl, user.photoUrl);
    });

    test('should handle empty photoUrl', () {
      final user = UserProfile(
        uid: '123',
        displayName: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: '',
      );

      expect(user.photoUrl, '');
    });

    test('should handle special characters in displayName', () {
      final user = UserProfile(
        uid: '123',
        displayName: 'José María García-López',
        email: 'jose@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.displayName, 'José María García-López');
    });

    test('should handle complex email addresses', () {
      final user = UserProfile(
        uid: '123',
        displayName: 'Test User',
        email: 'test.user+tag@example.co.uk',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.email, 'test.user+tag@example.co.uk');
    });
  });
}
