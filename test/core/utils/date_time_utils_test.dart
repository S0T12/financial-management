import 'package:financial_management/core/utils/date_time_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeUtils', () {
    test('should convert DateTime to Jalali string', () {
      final date = DateTime(2024, 3, 20); // Esfand 30, 1402
      final result = DateTimeUtils.toJalaliString(date);
      
      expect(result, contains('1402'));
    });
    
    test('should get start of day correctly', () {
      final date = DateTime(2024, 3, 20, 15, 30, 45);
      final result = DateTimeUtils.startOfDay(date);
      
      expect(result.hour, 0);
      expect(result.minute, 0);
      expect(result.second, 0);
    });
    
    test('should get end of day correctly', () {
      final date = DateTime(2024, 3, 20, 10, 30);
      final result = DateTimeUtils.endOfDay(date);
      
      expect(result.hour, 23);
      expect(result.minute, 59);
      expect(result.second, 59);
    });
    
    test('should check if date is today', () {
      final today = DateTime.now();
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      
      expect(DateTimeUtils.isToday(today), isTrue);
      expect(DateTimeUtils.isToday(yesterday), isFalse);
    });
  });
  
  group('NumberUtils', () {
    test('should format currency with Persian digits', () {
      final result = NumberUtils.formatCurrency(1209000, locale: 'fa');
      
      expect(result, contains('۱'));
      expect(result, contains('،'));
    });
    
    test('should format currency with English digits', () {
      final result = NumberUtils.formatCurrency(1209000, locale: 'en');
      
      expect(result, contains('1'));
      expect(result, contains(','));
    });
    
    test('should format compact numbers in Persian', () {
      expect(NumberUtils.formatCompact(1200000, locale: 'fa'), contains('میلیون'));
      expect(NumberUtils.formatCompact(1200000000, locale: 'fa'), contains('میلیارد'));
    });
    
    test('should format compact numbers in English', () {
      expect(NumberUtils.formatCompact(1200000, locale: 'en'), contains('M'));
      expect(NumberUtils.formatCompact(1200000000, locale: 'en'), contains('B'));
    });
    
    test('should parse amount with thousand separators', () {
      final result1 = NumberUtils.parseAmount('1,209,000');
      final result2 = NumberUtils.parseAmount('۱،۲۰۹،۰۰۰');
      
      expect(result1, 1209000);
      expect(result2, 1209000);
    });
  });
}
