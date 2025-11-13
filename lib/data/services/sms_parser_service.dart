import 'package:equatable/equatable.dart';

/// Parsed SMS transaction data
class ParsedSmsTransaction extends Equatable {
  final int amount;
  final String? accountNumber;
  final int? balance;
  final String? bankName;
  final DateTime? dateTime;
  final bool isExpense;
  final String originalMessage;
  
  const ParsedSmsTransaction({
    required this.amount,
    this.accountNumber,
    this.balance,
    this.bankName,
    this.dateTime,
    required this.isExpense,
    required this.originalMessage,
  });
  
  @override
  List<Object?> get props => [
    amount,
    accountNumber,
    balance,
    bankName,
    dateTime,
    isExpense,
    originalMessage,
  ];
}

/// SMS parsing service for Iranian bank messages
class SmParserService {
  SmParserService._();
  
  static final instance = SmParserService._();
  
  /// Parse Iranian bank SMS message
  /// Returns null if SMS is not a valid transaction message
  ParsedSmsTransaction? parseBankSms(String message, {DateTime? receivedAt}) {
    if (!_isBankSms(message)) {
      return null;
    }
    
    // Extract amount
    final amount = _extractAmount(message);
    if (amount == null) {
      return null;
    }
    
    // Determine transaction type (+ for income, - for expense)
    final isExpense = _isExpenseTransaction(message);
    
    // Extract account number
    final accountNumber = _extractAccountNumber(message);
    
    // Extract balance
    final balance = _extractBalance(message);
    
    // Extract bank name
    final bankName = _extractBankName(message);
    
    // Extract date and time
    final dateTime = _extractDateTime(message, receivedAt);
    
    return ParsedSmsTransaction(
      amount: amount,
      accountNumber: accountNumber,
      balance: balance,
      bankName: bankName,
      dateTime: dateTime,
      isExpense: isExpense,
      originalMessage: message,
    );
  }
  
  /// Check if message is from a bank
  bool _isBankSms(String message) {
    // Check for common Persian bank keywords
    final bankKeywords = [
      'بانك',
      'بانک',
      'حساب',
      'کارت',
      'مانده',
      'انتقال',
      'برداشت',
      'واریز',
    ];
    
    return bankKeywords.any((keyword) => message.contains(keyword));
  }
  
  /// Extract amount from SMS
  /// Handles formats like: "1,209,000-" or "۱،۲۰۹،۰۰۰-"
  int? _extractAmount(String message) {
    // Patterns for amount extraction
    final patterns = [
      // Format: انتقال:1,209,000- or برداشت:1,209,000-
      RegExp(r'(?:انتقال|برداشت|واریز)[:\s]*([0-9۰-۹,،]+)[-\+]?'),
      // Format: مبلغ 1,209,000 ریال
      RegExp(r'مبلغ[:\s]*([0-9۰-۹,،]+)'),
      // Format: 1,209,000- (standalone)
      RegExp(r'([0-9۰-۹,،]+)[-\+]'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final amountStr = match.group(1)!;
        return _parseAmount(amountStr);
      }
    }
    
    return null;
  }
  
  /// Parse amount string to integer
  int _parseAmount(String amountStr) {
    // Convert Persian digits to English
    String cleaned = _convertPersianToEnglish(amountStr);
    
    // Remove thousand separators (, or ،)
    cleaned = cleaned.replaceAll(RegExp(r'[,،]'), '');
    
    return int.tryParse(cleaned) ?? 0;
  }
  
  /// Check if transaction is expense (has minus sign)
  bool _isExpenseTransaction(String message) {
    // Look for patterns indicating expense
    final expenseKeywords = ['انتقال', 'برداشت', 'خرید', 'پرداخت'];
    final hasExpenseKeyword = expenseKeywords.any((k) => message.contains(k));
    
    // Look for minus sign after amount
    final hasMinus = message.contains(RegExp(r'[0-9۰-۹,،]+-'));
    
    // Look for income keywords
    final incomeKeywords = ['واریز', 'افزایش'];
    final hasIncomeKeyword = incomeKeywords.any((k) => message.contains(k));
    
    if (hasIncomeKeyword) return false;
    if (hasMinus || hasExpenseKeyword) return true;
    
    return true; // Default to expense
  }
  
  /// Extract account number
  String? _extractAccountNumber(String message) {
    // Pattern: حساب:61006 or کارت:6037
    final patterns = [
      RegExp(r'حساب[:\s]*([0-9۰-۹]+)'),
      RegExp(r'کارت[:\s]*([0-9۰-۹]+)'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        return _convertPersianToEnglish(match.group(1)!);
      }
    }
    
    return null;
  }
  
  /// Extract balance from SMS
  int? _extractBalance(String message) {
    // Pattern: مانده:71,144,085
    final patterns = [
      RegExp(r'مانده[:\s]*([0-9۰-۹,،]+)'),
      RegExp(r'موجودی[:\s]*([0-9۰-۹,،]+)'),
    ];
    
    for (final pattern in patterns) {
      final match = pattern.firstMatch(message);
      if (match != null) {
        final balanceStr = match.group(1)!;
        return _parseAmount(balanceStr);
      }
    }
    
    return null;
  }
  
  /// Extract bank name
  String? _extractBankName(String message) {
    final bankNames = {
      'ملي': 'بانک ملی',
      'صادرات': 'بانک صادرات',
      'ملت': 'بانک ملت',
      'پاسارگاد': 'بانک پاسارگاد',
      'تجارت': 'بانک تجارت',
      'سپه': 'بانک سپه',
      'پارسیان': 'بانک پارسیان',
      'کشاورزی': 'بانک کشاورزی',
      'مسکن': 'بانک مسکن',
      'سامان': 'بانک سامان',
    };
    
    for (final entry in bankNames.entries) {
      if (message.contains(entry.key)) {
        return entry.value;
      }
    }
    
    return null;
  }
  
  /// Extract date and time from SMS
  DateTime? _extractDateTime(String message, DateTime? receivedAt) {
    // Pattern: 0822-12:34 or 08/22-12:34
    final pattern = RegExp(r'(\d{2})[/\-](\d{2})[:\-\s]*(\d{2}):(\d{2})');
    final match = pattern.firstMatch(message);
    
    if (match != null) {
      final month = int.parse(match.group(1)!);
      final day = int.parse(match.group(2)!);
      final hour = int.parse(match.group(3)!);
      final minute = int.parse(match.group(4)!);
      
      final now = receivedAt ?? DateTime.now();
      return DateTime(now.year, month, day, hour, minute);
    }
    
    return receivedAt ?? DateTime.now();
  }
  
  /// Convert Persian/Arabic digits to English
  String _convertPersianToEnglish(String text) {
    const persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    
    String result = text;
    for (int i = 0; i < 10; i++) {
      result = result.replaceAll(persianDigits[i], i.toString());
      result = result.replaceAll(arabicDigits[i], i.toString());
    }
    
    return result;
  }
}
