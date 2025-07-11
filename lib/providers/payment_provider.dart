import 'package:appoint/services/payment_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentServiceProvider =
    Provider<PaymentService>((ref) => PaymentService());
