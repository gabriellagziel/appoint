import 'package:appoint/features/home/widgets/greeting_header.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('greetFor returns Good morning at 09:00', () {
    expect(greetFor(DateTime(2025, 1, 1, 9, 0)), 'Good morning');
  });

  test('greetFor returns Good evening at 19:00', () {
    expect(greetFor(DateTime(2025, 1, 1, 19, 0)), 'Good evening');
  });
}










