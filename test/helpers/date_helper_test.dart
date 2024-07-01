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

  group('Test parsing of formatted dates', () {
    test('Test the date parser', () {
      DateTime dateToFormat = DateTime(2024, 1, 1);

      String formattedDate = DateHelper.formatDate(dateToFormat);
      DateTime? parsedDate = DateHelper.parseDate(formattedDate);

      expect(parsedDate, dateToFormat);
    });

    test('Test the date format for invalid string', () {
      String formattedDate = "invalid date format";
      DateTime? parsedDate = DateHelper.parseDate(formattedDate);

      expect(parsedDate, isNull);
    });
  });

  group('Test removing time component', () {
    test('Test the time removal', () {
      DateTime dateToParse = DateTime(2024, 1, 1, 12, 30, 45);

      DateTime parsedDate = DateHelper.removeTime(dateToParse);

      expect(parsedDate.year, 2024);
      expect(parsedDate.month, 1);
      expect(parsedDate.day, 1);

      expect(parsedDate.hour, 0);
      expect(parsedDate.minute, 0);
      expect(parsedDate.second, 0);
      expect(parsedDate.millisecond, 0);
      expect(parsedDate.microsecond, 0);
    });

    test('Test the time removal when no time specified', () {
      DateTime dateToParse = DateTime(2024, 1, 1);

      DateTime parsedDate = DateHelper.removeTime(dateToParse);

      expect(parsedDate.year, 2024);
      expect(parsedDate.month, 1);
      expect(parsedDate.day, 1);

      expect(parsedDate.hour, 0);
      expect(parsedDate.minute, 0);
      expect(parsedDate.second, 0);
      expect(parsedDate.millisecond, 0);
      expect(parsedDate.microsecond, 0);
    });
  });

  group('Test formatDifference method', () {
    test(
        'Given 2 dates, When the difference is over 1 year, Then display difference in years',
        () {
      // Arrange
      DateTime startDate = DateTime(2023, 1, 1);
      DateTime endDate = DateTime(2024, 1, 1);

      // Act
      String results = DateHelper.formatDifference(startDate, endDate);

      expect(results, '1 Year');
    });

    test(
        'Given 2 dates, When the difference is over 2 year, Then display difference in years',
        () {
      // Arrange
      DateTime startDate = DateTime(2022, 1, 1);
      DateTime endDate = DateTime(2024, 1, 1);

      // Act
      String results = DateHelper.formatDifference(startDate, endDate);

      expect(results, '2 Years');
    });

    test(
        'Given 2 dates, When the difference is 6 months, Then display difference in months',
        () {
      // Arrange
      DateTime startDate = DateTime(2024, 1, 1);
      DateTime endDate = DateTime(2024, 7, 1);

      // Act
      String results = DateHelper.formatDifference(startDate, endDate);

      expect(results, '6 Months');
    });

    test(
        'Given 2 dates, When the difference is less than 30 days, Then display difference in days',
        () {
      // Arrange
      DateTime startDate = DateTime(2024, 1, 1);
      DateTime endDate = DateTime(2024, 1, 21);

      // Act
      String results = DateHelper.formatDifference(startDate, endDate);

      expect(results, '20 Days');
    });

    test(
        'Given 2 dates, When the dates are the same, Then display 0 days',
        () {
      // Arrange
      DateTime startDate = DateTime(2024, 1, 1);
      DateTime endDate = DateTime(2024, 1, 1);

      // Act
      String results = DateHelper.formatDifference(startDate, endDate);

      expect(results, '0 Days');
    });

    test(
        'Given 2 dates, When the end date is before the start date, Then display 0 days',
        () {
      // Arrange
      DateTime startDate = DateTime(2024, 1, 1);
      DateTime endDate = DateTime(2023, 1, 1);

      // Act
      String results = DateHelper.formatDifference(startDate, endDate);

      expect(results, '0 Days');
    });
  });
}
