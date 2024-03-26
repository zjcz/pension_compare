import 'package:intl/intl.dart';

class CurrencyHelper {
  static String formatCurrency(double? value, [String currencySymbol = '']) {
    if (value == null) {
      return '';
    }

    return NumberFormat.currency(locale: 'en_GB', symbol: currencySymbol)
        .format(value);
  }

  static double? parseCurrency(String? value, [String currencySymbol = '']) {
    if (value == null || value.isEmpty) {
      return null;
    }

    return double.tryParse(
        value.replaceAll(currencySymbol, '').replaceAll(',', ''));
  }
}
