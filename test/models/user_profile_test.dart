@Skip('Pending Firebase setup conflicts')
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/user_profile.dart';
import '../test_setup.dart';

void main() {
  setUpAll(() async {
    await registerFirebaseMock();
  });

  group('UserProfile Model', () {
    test('should correctly create a user profile', () {
      final user = UserProfile(
        id: '123',
        name: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.id, '123');
      expect(user.name, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
    });

    test('should be able to convert to JSON and back', () {
      final user = UserProfile(
        id: '123',
        name: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

      final json = user.toJson();
      final newUser = UserProfile.fromJson(json);

      expect(newUser.id, user.id);
      expect(newUser.name, user.name);
      expect(newUser.email, user.email);
      expect(newUser.photoUrl, user.photoUrl);
    });

    test('should handle empty photoUrl', () {
      final user = UserProfile(
        id: '123',
        name: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: '',
      );

      expect(user.photoUrl, '');
    });

    test('should handle special characters in name', () {
      final user = UserProfile(
        id: '123',
        name: 'José María García-López',
        email: 'jose@example.com',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.name, 'José María García-López');
    });

    test('should handle complex email addresses', () {
      final user = UserProfile(
        id: '123',
        name: 'Test User',
        email: 'test.user+tag@example.co.uk',
        photoUrl: 'https://example.com/photo.jpg',
      );

      expect(user.email, 'test.user+tag@example.co.uk');
    });
  });
}
