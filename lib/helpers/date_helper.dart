import 'package:intl/intl.dart';

class DateHelper {
  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy').format(date);
  }

  /// Get today's date, minus the time segment
  static DateTime getToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }
}
