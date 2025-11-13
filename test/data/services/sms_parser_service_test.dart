import 'package:financial_management/data/services/sms_parser_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SmsParserService smsParser;
  
  setUp(() {
    smsParser = SmsParserService.instance;
  });
  
  group('SmsParserService', () {
    test('should parse Bank Melli transaction SMS correctly', () {
      // Arrange
      const smsMessage = '''
بانك ملي ايران
انتقال:1,209,000-
حساب:61006
مانده:71,144,085
0822-12:34
''';
      
      // Act
      final result = smsParser.parseBankSms(smsMessage);
      
      // Assert
      expect(result, isNotNull);
      expect(result!.amount, 1209000);
      expect(result.isExpense, isTrue);
      expect(result.accountNumber, '61006');
      expect(result.balance, 71144085);
      expect(result.bankName, 'بانک ملی');
    });
    
    test('should parse expense transaction with minus sign', () {
      // Arrange
      const smsMessage = '''
بانک صادرات
برداشت:500,000-
کارت:6037
مانده:2,500,000
''';
      
      // Act
      final result = smsParser.parseBankSms(smsMessage);
      
      // Assert
      expect(result, isNotNull);
      expect(result!.amount, 500000);
      expect(result.isExpense, isTrue);
      expect(result.accountNumber, '6037');
      expect(result.balance, 2500000);
    });
    
    test('should parse income transaction correctly', () {
      // Arrange
      const smsMessage = '''
بانک ملت
واریز:2,000,000+
حساب:12345
مانده:5,000,000
''';
      
      // Act
      final result = smsParser.parseBankSms(smsMessage);
      
      // Assert
      expect(result, isNotNull);
      expect(result!.amount, 2000000);
      expect(result.isExpense, isFalse);
    });
    
    test('should handle Persian digits correctly', () {
      // Arrange
      const smsMessage = '''
بانک پاسارگاد
انتقال:۱،۲۰۰،۰۰۰-
حساب:۶۱۰۰۶
مانده:۷۱،۱۴۴،۰۸۵
''';
      
      // Act
      final result = smsParser.parseBankSms(smsMessage);
      
      // Assert
      expect(result, isNotNull);
      expect(result!.amount, 1200000);
      expect(result.accountNumber, '61006');
      expect(result.balance, 71144085);
    });
    
    test('should return null for non-bank SMS', () {
      // Arrange
      const smsMessage = 'Hello, this is a regular text message';
      
      // Act
      final result = smsParser.parseBankSms(smsMessage);
      
      // Assert
      expect(result, isNull);
    });
    
    test('should return null for SMS without amount', () {
      // Arrange
      const smsMessage = '''
بانک ملی
مشخصات حساب
شماره: 61006
''';
      
      // Act
      final result = smsParser.parseBankSms(smsMessage);
      
      // Assert
      expect(result, isNull);
    });
    
    test('should parse different bank names correctly', () {
      final bankMessages = [
        ('بانك ملي ايران\nانتقال:100,000-', 'بانک ملی'),
        ('بانک صادرات\nانتقال:100,000-', 'بانک صادرات'),
        ('بانک ملت\nانتقال:100,000-', 'بانک ملت'),
        ('بانک پاسارگاد\nانتقال:100,000-', 'بانک پاسارگاد'),
        ('بانک سامان\nانتقال:100,000-', 'بانک سامان'),
      ];
      
      for (final (message, expectedBank) in bankMessages) {
        final result = smsParser.parseBankSms(message);
        expect(result?.bankName, expectedBank);
      }
    });
  });
}
