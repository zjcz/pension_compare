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

  static String getCurrencySymbol() {
    return NumberFormat.simpleCurrency().currencySymbol;
  }

  static bool validateCurrencyValue(String? value,
      {bool allowNegative = false, bool allowNull = false}) {
    bool result = false;

    if (value != null && value.isNotEmpty) {
      double? parsedValue = double.tryParse(value);
      result = parsedValue != null;

      if (result && !allowNegative) {
        result = parsedValue >= 0;
      }
    } else if (allowNull) {
      result = true;
    }

    return result;
  }
}
