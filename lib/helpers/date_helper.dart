import 'package:intl/intl.dart';

class DateHelper {
  static const String dateFormat = 'dd MMMM yyyy';

  static String formatDate(DateTime date) {
    return DateFormat(dateFormat).format(date);
  }

  static DateTime? parseDate(String date) {
    return DateFormat(dateFormat).tryParse(date);
  }

  /// Get today's date, minus the time segment
  static DateTime getToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  // Remove the time component from the dateTime object
  static DateTime removeTime(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
}
