import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/services/payment_service.dart';

final paymentServiceProvider =
    Provider<PaymentService>((final ref) => PaymentService());
