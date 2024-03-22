import 'package:pension_compare/helpers/date_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Test formatting of dates', () {
    test('Test the date format', () {
      DateTime dateToFormat = DateTime(2024, 1, 1);

      String formattedDate = DateHelper.formatDate(dateToFormat);

      expect(formattedDate, '01 January 2024');
    });

    test('Test the date format for February', () {
      DateTime dateToFormat = DateTime(2024, 2, 29);

      String formattedDate = DateHelper.formatDate(dateToFormat);

      expect(formattedDate, '29 February 2024');
    });
  });

  group('Test get todays date', () {
    test('Test the date has no time elements', () {
      DateTime dateToTest = DateHelper.getToday();

      expect(dateToTest.hour, 0);
      expect(dateToTest.minute, 0);
      expect(dateToTest.second, 0);
      expect(dateToTest.microsecond, 0);
    });
  });
}
