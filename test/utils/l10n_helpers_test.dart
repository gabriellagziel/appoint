import 'package:appoint/utils/l10n_helpers.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('plural helper', () {
    test('zero returns plural-zero form', () {
      expect(
        plural(count: 0, zero: 'none', one: 'one', many: 'many'),
        equals('none'),
      );
    });
    test('one returns singular', () {
      expect(
        plural(count: 1, zero: 'none', one: 'one', many: 'many'),
        equals('one'),
      );
    });
    test('two or more returns many', () {
      expect(
        plural(count: 5, zero: 'none', one: 'one', many: 'many'),
        equals('many'),
      );
    });
  });

  group('gender helper', () {
    test('male returns male string', () {
      expect(gender(isMale: true, male: 'Mr', female: 'Ms'), equals('Mr'));
    });
    test('female returns female string', () {
      expect(gender(isMale: false, male: 'Mr', female: 'Ms'), equals('Ms'));
    });
  });
}
