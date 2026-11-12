import 'package:intl/intl.dart';

/// Formats an integer amount in cents as USD for the portfolio demo.
String formatPriceInCents(int priceInCents, {String locale = 'en_US'}) {
  return NumberFormat.simpleCurrency(locale: locale).format(priceInCents / 100);
}
