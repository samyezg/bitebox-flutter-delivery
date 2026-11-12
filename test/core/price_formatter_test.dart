import 'package:bitebox_app/core/utils/price_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('formats cents as USD', () {
    expect(formatPriceInCents(899), r'$8.99');
    expect(formatPriceInCents(1299), r'$12.99');
  });
}
