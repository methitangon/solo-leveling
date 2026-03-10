import 'package:intl/intl.dart';

/// Helper class for date operations
class DateHelper {
  /// Get today's date as string (YYYY-MM-DD)
  static String getTodayString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  /// Get date string from DateTime
  static String getDateString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  /// Parse date string to DateTime
  static DateTime parseDate(String dateString) {
    return DateFormat('yyyy-MM-dd').parse(dateString);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    return isSameDay(date, DateTime.now());
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return isSameDay(date, yesterday);
  }

  /// Get start of day
  static DateTime getStartOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime getEndOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Format date for display (e.g., "Mar 10, 2026")
  static String formatDisplayDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  /// Format time for display (e.g., "2:30 PM")
  static String formatDisplayTime(DateTime date) {
    return DateFormat('h:mm a').format(date);
  }

  /// Format date and time (e.g., "Mar 10, 2026 at 2:30 PM")
  static String formatDisplayDateTime(DateTime date) {
    return DateFormat('MMM dd, yyyy \'at\' h:mm a').format(date);
  }

  /// Get relative time string (e.g., "2 hours ago", "just now")
  static String getRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return formatDisplayDate(date);
    }
  }

  /// Get unix timestamp (milliseconds since epoch)
  static int getUnixTimestamp(DateTime date) {
    return date.millisecondsSinceEpoch;
  }

  /// Get DateTime from unix timestamp
  static DateTime fromUnixTimestamp(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Get current unix timestamp
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
