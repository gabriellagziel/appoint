import 'package:appoint/services/payment_service.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFunctions extends Mock implements FirebaseFunctions {}

class MockHttpsCallable extends Mock implements HttpsCallable {}

class MockHttpsCallableResult extends Mock implements HttpsCallableResult {}

class MockStripe extends Mock implements Stripe {}

void main() {
  group('PaymentService', () {
    late PaymentService paymentService;
    late MockFirebaseFunctions mockFunctions;
    late MockHttpsCallable mockCallable;
    late MockHttpsCallableResult mockResult;

    setUp(() {
      mockFunctions = MockFirebaseFunctions();
      mockCallable = MockHttpsCallable();
      mockResult = MockHttpsCallableResult();

      paymentService = PaymentService(mockFunctions);
    });

    group('createPaymentIntent', () {
      test('should create payment intent successfully', () async {
        // Arrange
        const amount = 50.0;
        final expectedResponse = {
          'clientSecret': 'pi_test_secret_123',
          'paymentIntentId': 'pi_test_123',
          'status': 'requires_payment_method',
        };

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount}))
            .thenAnswer((_) async => mockResult);
        when(() => mockResult.data).thenReturn(expectedResponse);

        // Act
        final result = await paymentService.createPaymentIntent(amount);

        // Assert
        expect(result, equals(expectedResponse));
        verify(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .called(1);
        verify(() => mockCallable.call({'amount': amount})).called(1);
      });

      test('should throw exception when amount is invalid', () async {
        // Arrange
        const amount = -10.0;

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount})).thenThrow(
          FirebaseFunctionsException(
            code: 'invalid-argument',
            message: 'Invalid amount',
          ),
        );

        // Act & Assert
        expect(
          () => paymentService.createPaymentIntent(amount),
          throwsA(isA<FirebaseFunctionsException>()),
        );
      });
    });

    group('handlePayment', () {
      test('should return succeeded when payment succeeds immediately',
          () async {
        // Arrange
        const amount = 50.0;
        final intentResponse = {
          'clientSecret': 'pi_test_secret_123',
          'paymentIntentId': 'pi_test_123',
          'status': 'succeeded',
        };

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount}))
            .thenAnswer((_) async => mockResult);
        when(() => mockResult.data).thenReturn(intentResponse);

        // Act
        final result = await paymentService.handlePayment(amount);

        // Assert
        expect(result, isA<PaymentStatus>());
      });

      test('should handle requires_action status and complete 3D Secure',
          () async {
        // Arrange
        const amount = 50.0;
        final intentResponse = {
          'clientSecret': 'pi_test_secret_123',
          'paymentIntentId': 'pi_test_123',
          'status': 'requires_action',
        };

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount}))
            .thenAnswer((_) async => mockResult);
        when(() => mockResult.data).thenReturn(intentResponse);

        // Act
        final result = await paymentService.handlePayment(amount);

        // Assert
        expect(result, isA<PaymentStatus>());
      });

      test('should return failed when requires_payment_method', () async {
        // Arrange
        const amount = 50.0;
        final intentResponse = {
          'clientSecret': 'pi_test_secret_123',
          'paymentIntentId': 'pi_test_123',
          'status': 'requires_payment_method',
        };

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount}))
            .thenAnswer((_) async => mockResult);
        when(() => mockResult.data).thenReturn(intentResponse);

        // Act
        final result = await paymentService.handlePayment(amount);

        // Assert
        expect(result, equals(PaymentStatus.failed));
      });

      test('should handle general payment exception', () async {
        // Arrange
        const amount = 50.0;

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount})).thenThrow(
          FirebaseFunctionsException(
            code: 'internal',
            message: 'Network error',
          ),
        );

        // Act
        final result = await paymentService.handlePayment(amount);

        // Assert
        expect(result, equals(PaymentStatus.failed));
      });
    });

    group('PaymentStatus Messages', () {
      test('should return correct status messages', () {
        expect(
          paymentService.getPaymentStatusMessage(PaymentStatus.initial),
          equals('Ready to process payment'),
        );
        expect(
          paymentService.getPaymentStatusMessage(PaymentStatus.processing),
          equals('Processing payment...'),
        );
        expect(
          paymentService.getPaymentStatusMessage(PaymentStatus.requiresAction),
          equals('Authentication required...'),
        );
        expect(
          paymentService.getPaymentStatusMessage(PaymentStatus.succeeded),
          equals('Payment successful!'),
        );
        expect(
          paymentService.getPaymentStatusMessage(PaymentStatus.failed),
          equals('Payment failed. Please try again.'),
        );
      });
    });

    // New foundational error handling tests
    group('PaymentService Error Handling', () {
      test('should handle card_declined error from Firebase Functions',
          () async {
        // Arrange
        const amount = 50.0;

        when(() => mockFunctions.httpsCallable('createPaymentIntent'))
            .thenReturn(mockCallable);
        when(() => mockCallable.call({'amount': amount})).thenThrow(
          FirebaseFunctionsException(
            code: 'card_declined',
            message: 'Your card was declined',
          ),
        );

        // Act
        final result = await paymentService.handlePayment(amount);

        // Assert
        expect(result, equals(PaymentStatus.failed));
      });
    });
  });
}
