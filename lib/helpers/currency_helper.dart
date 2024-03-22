import 'package:intl/intl.dart';

class CurrencyHelper {
  static String formatCurrency(double value, [String currencySymbol = '']) {
    return NumberFormat.currency(locale: 'en_GB', symbol: currencySymbol)
        .format(value);
  }
}
