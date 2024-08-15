import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Test formatting of currency', () {
    test('Test the currency format', () {
      double value = 1234.56;

      String formattedValue = CurrencyHelper.formatCurrency(value);

      expect(formattedValue, '1,234.56');
    });

    test('Test the currency format for no decimal places', () {
      double value = 123;

      String formattedValue = CurrencyHelper.formatCurrency(value);

      expect(formattedValue, '123.00');
    });

    test('Test the currency format to 1 decimal place', () {
      double value = 123.4;

      String formattedValue = CurrencyHelper.formatCurrency(value);

      expect(formattedValue, '123.40');
    });

    test('Test the currency format for 3 decimal places', () {
      double value = 123.456;

      String formattedValue = CurrencyHelper.formatCurrency(value);

      expect(formattedValue, '123.46');
    });

    test('Test the currency format with symbol', () {
      double value = 1234.56;

      String formattedValue = CurrencyHelper.formatCurrency(value, '£');

      expect(formattedValue, '£1,234.56');
    });

    test('Test the currency format for null value', () {
      String formattedValue = CurrencyHelper.formatCurrency(null);

      expect(formattedValue, '');
    });
  });

  group('Test parsing of currency', () {
    test('Test the currency parser', () {
      String value = "1234.56";

      double? parsedValue = CurrencyHelper.parseCurrency(value);

      expect(parsedValue, 1234.56);
    });

    test('Test to 1 decimal place', () {
      String value = "1234.50";

      double? parsedValue = CurrencyHelper.parseCurrency(value);

      expect(parsedValue, 1234.5);
    });

    test('Test with currency symbol', () {
      String value = "£1234.50";

      double? parsedValue = CurrencyHelper.parseCurrency(value, '£');

      expect(parsedValue, 1234.5);
    });

    test('Test with null', () {
      String? value;

      double? parsedValue = CurrencyHelper.parseCurrency(value);

      expect(parsedValue, null);
    });

    test('Test with empty string', () {
      String value = '';

      double? parsedValue = CurrencyHelper.parseCurrency(value);

      expect(parsedValue, null);
    });

    test('Test with invalid string', () {
      String? value = 'invalid';

      double? parsedValue = CurrencyHelper.parseCurrency(value);

      expect(parsedValue, null);
    });
  });

  group('Test validating currency values', () {
    test('validate currency with decimal point', () {
      String value = "1234.56";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, true);
    });

    test('validate currency with no decimal point', () {
      String value = "1234";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, true);
    });

    test('validate currency with no value', () {
      String value = "";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, false);
    });

    test('validate currency with null value', () {
      String? value;

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, false);
    });

    test('validate currency with no value when nulls are allowed', () {
      String value = "";

      bool result =
          CurrencyHelper.validateCurrencyValue(value, allowNull: true);

      expect(result, true);
    });

    test('validate currency with null value when nulls are allowed', () {
      String? value;

      bool result =
          CurrencyHelper.validateCurrencyValue(value, allowNull: true);

      expect(result, true);
    });

    test('validate currency with zero value', () {
      String value = "0";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, true);
    });

    test('validate currency with zero value with decimal point', () {
      String value = "0.00";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, true);
    });

    test('validate currency with negative value', () {
      String value = "-1234";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, false);
    });

    test('validate currency with negative value when negatives are allowed',
        () {
      String value = "-1234";

      bool result =
          CurrencyHelper.validateCurrencyValue(value, allowNegative: true);

      expect(result, true);
    });

    test('validate currency with invalid value', () {
      String value = "invalid";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, false);
    });

    test('validate currency with decimal point and comma', () {
      String value = "1,234.56";

      bool result = CurrencyHelper.validateCurrencyValue(value);

      expect(result, true);
    });
  });
}
