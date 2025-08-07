import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:appoint_sdk/appoint_sdk.dart';
import 'package:appoint_sdk/models/user.dart';
import 'package:appoint_sdk/models/business.dart';
import 'package:appoint_sdk/models/booking.dart';
import 'package:appoint_sdk/models/auth_response.dart';
import 'package:appoint_sdk/exceptions/appoint_exception.dart';

void main() {
  group('AppointSDK', () {
    late AppointSDK sdk;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient((request) async {
        // Mock responses based on request URL
        if (request.url.path == '/auth/login') {
          return http.Response(
            '{"token": "test_token_123", "user": {"id": "user123", "email": "test@example.com", "name": "Test User", "role": "user", "createdAt": "2025-01-01T00:00:00Z"}}',
            200,
            headers: {'content-type': 'application/json'},
          );
        } else if (request.url.path == '/api/users/profile') {
          return http.Response(
            '{"id": "user123", "email": "test@example.com", "name": "Test User", "role": "user", "createdAt": "2025-01-01T00:00:00Z"}',
            200,
            headers: {'content-type': 'application/json'},
          );
        } else if (request.url.path == '/api/businesses/search') {
          return http.Response(
            '[{"id": "business123", "name": "Test Business", "description": "A test business", "address": "123 Test St", "phone": "+1-555-123-4567", "email": "test@business.com", "services": ["consultation", "treatment"]}]',
            200,
            headers: {'content-type': 'application/json'},
          );
        } else if (request.url.path == '/api/businesses/business123') {
          return http.Response(
            '{"id": "business123", "name": "Test Business", "description": "A test business", "address": "123 Test St", "phone": "+1-555-123-4567", "email": "test@business.com", "services": ["consultation", "treatment"]}',
            200,
            headers: {'content-type': 'application/json'},
          );
        } else if (request.url.path == '/api/bookings') {
          if (request.method == 'GET') {
            return http.Response(
              '[{"id": "booking123", "userId": "user123", "businessId": "business123", "scheduledAt": "2025-01-27T10:00:00Z", "serviceType": "consultation", "status": "confirmed", "notes": "Test booking", "location": "123 Test St", "createdAt": "2025-01-26T00:00:00Z"}]',
              200,
              headers: {'content-type': 'application/json'},
            );
          } else if (request.method == 'POST') {
            return http.Response(
              '{"id": "booking123", "userId": "user123", "businessId": "business123", "scheduledAt": "2025-01-27T10:00:00Z", "serviceType": "consultation", "status": "pending", "notes": "Test booking", "location": "123 Test St", "createdAt": "2025-01-26T00:00:00Z"}',
              201,
              headers: {'content-type': 'application/json'},
            );
          }
        } else if (request.url.path == '/health/liveness') {
          return http.Response('{"status": "healthy"}', 200);
        } else if (request.url.path == '/health/readiness') {
          return http.Response('{"status": "ready"}', 200);
        }
        
        return http.Response('Not found', 404);
      });
      
      sdk = AppointSDK();
      sdk.initialize(baseUrl: 'https://api.appoint.com/v1');
    });

    tearDown(() {
      sdk.dispose();
    });

    group('Initialization', () {
      test('should initialize with base URL', () {
        expect(() => sdk.initialize(baseUrl: 'https://api.appoint.com/v1'), returnsNormally);
      });

      test('should throw exception when not initialized', () {
        final newSdk = AppointSDK();
        expect(
          () => newSdk.authenticate(email: 'test@example.com', password: 'password123'),
          throwsA(isA<AppointException>()),
        );
      });
    });

    group('Authentication', () {
      test('should authenticate successfully', () async {
        final response = await sdk.authenticate(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(response, isA<AuthResponse>());
        expect(response.token, equals('test_token_123'));
        expect(response.user, isA<User>());
        expect(response.user.email, equals('test@example.com'));
        expect(response.user.name, equals('Test User'));
      });

      test('should throw exception for short password', () {
        expect(
          () => sdk.authenticate(email: 'test@example.com', password: '123'),
          throwsA(isA<AppointException>()),
        );
      });

      test('should handle authentication failure', () async {
        mockClient = MockClient((request) async {
          return http.Response(
            '{"error": "Invalid credentials"}',
            401,
            headers: {'content-type': 'application/json'},
          );
        });

        expect(
          () => sdk.authenticate(email: 'test@example.com', password: 'wrongpassword'),
          throwsA(isA<AppointException>()),
        );
      });
    });

    group('User Management', () {
      setUp(() {
        sdk.setAuthToken('test_token_123');
      });

      test('should get current user', () async {
        final user = await sdk.getCurrentUser();

        expect(user, isA<User>());
        expect(user.id, equals('user123'));
        expect(user.email, equals('test@example.com'));
        expect(user.name, equals('Test User'));
        expect(user.role, equals(UserRole.user));
      });

      test('should throw exception when not authenticated', () {
        sdk.clearAuthToken();
        expect(
          () => sdk.getCurrentUser(),
          throwsA(isA<AppointException>()),
        );
      });
    });

    group('Business Search', () {
      test('should search businesses', () async {
        final businesses = await sdk.searchBusinesses(query: 'restaurant');

        expect(businesses, isA<List<Business>>());
        expect(businesses.length, equals(1));
        expect(businesses.first.id, equals('business123'));
        expect(businesses.first.name, equals('Test Business'));
        expect(businesses.first.services, contains('consultation'));
      });

      test('should get business details', () async {
        final business = await sdk.getBusiness(businessId: 'business123');

        expect(business, isA<Business>());
        expect(business.id, equals('business123'));
        expect(business.name, equals('Test Business'));
        expect(business.email, equals('test@business.com'));
        expect(business.services, contains('consultation'));
      });
    });

    group('Booking Management', () {
      setUp(() {
        sdk.setAuthToken('test_token_123');
      });

      test('should get user bookings', () async {
        final bookings = await sdk.getUserBookings();

        expect(bookings, isA<List<Booking>>());
        expect(bookings.length, equals(1));
        expect(bookings.first.id, equals('booking123'));
        expect(bookings.first.serviceType, equals('consultation'));
        expect(bookings.first.status, equals(BookingStatus.confirmed));
      });

      test('should create booking', () async {
        final booking = await sdk.createBooking(
          businessId: 'business123',
          scheduledAt: DateTime.parse('2025-01-27T10:00:00Z'),
          serviceType: 'consultation',
          notes: 'Test booking',
          location: '123 Test St',
        );

        expect(booking, isA<Booking>());
        expect(booking.id, equals('booking123'));
        expect(booking.businessId, equals('business123'));
        expect(booking.serviceType, equals('consultation'));
        expect(booking.status, equals(BookingStatus.pending));
        expect(booking.notes, equals('Test booking'));
      });

      test('should throw exception when not authenticated for bookings', () {
        sdk.clearAuthToken();
        expect(
          () => sdk.getUserBookings(),
          throwsA(isA<AppointException>()),
        );
      });
    });

    group('Health Checks', () {
      test('should check liveness', () async {
        final isAlive = await sdk.checkLiveness();
        expect(isAlive, isTrue);
      });

      test('should check readiness', () async {
        final isReady = await sdk.checkReadiness();
        expect(isReady, isTrue);
      });

      test('should handle health check failure', () async {
        mockClient = MockClient((request) async {
          return http.Response('Service unavailable', 503);
        });

        final isAlive = await sdk.checkLiveness();
        expect(isAlive, isFalse);
      });
    });

    group('Error Handling', () {
      test('should handle network errors', () async {
        mockClient = MockClient((request) async {
          throw Exception('Network error');
        });

        expect(
          () => sdk.authenticate(email: 'test@example.com', password: 'password123'),
          throwsA(isA<AppointException>()),
        );
      });

      test('should handle invalid JSON responses', () async {
        mockClient = MockClient((request) async {
          return http.Response('Invalid JSON', 200);
        });

        expect(
          () => sdk.authenticate(email: 'test@example.com', password: 'password123'),
          throwsA(isA<AppointException>()),
        );
      });
    });

    group('Token Management', () {
      test('should set and clear auth token', () {
        sdk.setAuthToken('test_token');
        sdk.clearAuthToken();
        
        expect(
          () => sdk.getCurrentUser(),
          throwsA(isA<AppointException>()),
        );
      });
    });
  });
} 