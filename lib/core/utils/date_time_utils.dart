import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

/// Utility class for date and time operations
class DateTimeUtils {
  DateTimeUtils._();
  
  /// Convert DateTime to Jalali date string
  static String toJalaliString(DateTime dateTime, {String format = 'yyyy/MM/dd'}) {
    final jalali = Jalali.fromDateTime(dateTime);
    // Format as yyyy/MM/dd manually since formatter.format() is not available
    return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
  }
  
  /// Convert DateTime to Jalali with time
  static String toJalaliWithTime(DateTime dateTime) {
    final jalali = Jalali.fromDateTime(dateTime);
    final time = DateFormat('HH:mm').format(dateTime);
    return '${jalali.formatter.yyyy}/${jalali.formatter.mm}/${jalali.formatter.dd} - $time';
  }
  
  /// Convert Jalali date to DateTime
  static DateTime fromJalali(int year, int month, int day) {
    final jalali = Jalali(year, month, day);
    return jalali.toDateTime();
  }
  
  /// Get start of day
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }
  
  /// Get end of day
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
  }
  
  /// Get start of month
  static DateTime startOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }
  
  /// Get end of month
  static DateTime endOfMonth(DateTime dateTime) {
    final nextMonth = dateTime.month == 12 
        ? DateTime(dateTime.year + 1, 1, 1)
        : DateTime(dateTime.year, dateTime.month + 1, 1);
    return nextMonth.subtract(const Duration(milliseconds: 1));
  }
  
  /// Get relative time string (e.g., "2 hours ago")
  static String getRelativeTime(DateTime dateTime, String locale) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return locale == 'fa' ? '$years سال پیش' : '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return locale == 'fa' ? '$months ماه پیش' : '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return locale == 'fa' ? '${difference.inDays} روز پیش' : '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return locale == 'fa' ? '${difference.inHours} ساعت پیش' : '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return locale == 'fa' ? '${difference.inMinutes} دقیقه پیش' : '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return locale == 'fa' ? 'چند لحظه پیش' : 'Just now';
    }
  }
  
  /// Check if date is today
  static bool isToday(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }
  
  /// Check if date is in current month
  static bool isCurrentMonth(DateTime dateTime) {
    final now = DateTime.now();
    return dateTime.year == now.year && dateTime.month == now.month;
  }
}

/// Utility class for number and currency formatting
class NumberUtils {
  NumberUtils._();
  
  /// Format number with Persian digits and thousand separators
  static String formatCurrency(int amount, {String locale = 'fa'}) {
    if (locale == 'fa') {
      return amount.toString().seRagham().toPersianDigit();
    }
    return NumberFormat('#,###').format(amount);
  }
  
  /// Format large numbers (e.g., 1,200,000 -> 1.2M)
  static String formatCompact(int amount, {String locale = 'fa'}) {
    if (amount >= 1000000000) {
      final billions = (amount / 1000000000).toStringAsFixed(1);
      return locale == 'fa' ? '$billions میلیارد'.toPersianDigit() : '${billions}B';
    } else if (amount >= 1000000) {
      final millions = (amount / 1000000).toStringAsFixed(1);
      return locale == 'fa' ? '$millions میلیون'.toPersianDigit() : '${millions}M';
    } else if (amount >= 1000) {
      final thousands = (amount / 1000).toStringAsFixed(1);
      return locale == 'fa' ? '$thousands هزار'.toPersianDigit() : '${thousands}K';
    }
    return formatCurrency(amount, locale: locale);
  }
  
  /// Parse Persian digits to English
  static String parseToEnglish(String text) {
    return text.toEnglishDigit();
  }
  
  /// Extract numbers from text
  static List<int> extractNumbers(String text) {
    final regex = RegExp(r'\d+');
    return regex.allMatches(text).map((m) => int.parse(m.group(0)!)).toList();
  }
  
  /// Remove thousand separators and parse to int
  static int parseAmount(String text) {
    final cleaned = text.toEnglishDigit().replaceAll(RegExp(r'[,،]'), '');
    return int.tryParse(cleaned) ?? 0;
  }
}
