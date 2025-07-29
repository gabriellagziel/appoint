import 'package:appoint/models/price_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const base = PriceModel(
    amount: 50,
    currency: 'USD',
  );

  group('copyWith', () {
    test('changes only specified fields', () {
      changed = base.copyWith(amount: 60);
      expect(changed.amount, 60.0);
      expect(changed.currency, base.currency);
    });
  });

  group('equality & hashCode', () {
    test('identical values are equal', () {
      const clone = PriceModel(amount: 50, currency: 'USD');
      expect(base, clone);
      expect(base.hashCode, clone.hashCode);
    });

    test('different values are not equal', () {
      const other = PriceModel(amount: 55, currency: 'USD');
      expect(base == other, isFalse);
    });
  });

  group('JSON', () {
    test('toJson / fromJson round-trip', () {
      json = base.toJson();
      roundTrip = PriceModel.fromJson(json);
      expect(roundTrip, base);
    });
  });
}
