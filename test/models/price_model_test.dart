import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/models/price_model.dart';

void main() {
  const base = PriceModel(
    amount: 50.0,
    currency: 'USD',
    discountPercent: 0,
  );

  group('copyWith', () {
    test('changes only specified fields', () {
      final changed = base.copyWith(amount: 60.0);
      expect(changed.amount, 60.0);
      expect(changed.currency, base.currency);
    });
  });

  group('equality & hashCode', () {
    test('identical values are equal', () {
      const clone = PriceModel(amount: 50.0, currency: 'USD', discountPercent: 0);
      expect(base, clone);
      expect(base.hashCode, clone.hashCode);
    });

    test('different values are not equal', () {
      const other = PriceModel(amount: 55.0, currency: 'USD', discountPercent: 0);
      expect(base == other, isFalse);
    });
  });

  group('JSON', () {
    test('toJson / fromJson round-trip', () {
      final json = base.toJson();
      final roundTrip = PriceModel.fromJson(json);
      expect(roundTrip, base);
    });
  });
}
