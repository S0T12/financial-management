/// Application-wide constants
class AppConstants {
  AppConstants._();
  
  // Database
  static const String databaseName = 'financial_management.db';
  static const int databaseVersion = 1;
  
  // SMS Parsing
  static const int minimumTransactionAmount = 300000; // 300,000 Rials
  static const List<String> supportedBanks = [
    'بانك ملي',
    'بانک ملی',
    'بانك صادرات',
    'بانک صادرات',
    'بانك ملت',
    'بانک ملت',
    'بانك پاسارگاد',
    'بانک پاسارگاد',
    'بانك تجارت',
    'بانک تجارت',
    'بانك سپه',
    'بانک سپه',
  ];
  
  // Date & Time
  static const String dateFormat = 'yyyy/MM/dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy/MM/dd HH:mm';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // File & Image
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedImageFormats = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Security
  static const String secureStorageKey = 'financial_management_secure';
  static const int pinLength = 4;
  static const int maxLoginAttempts = 5;
  
  // Localization
  static const String defaultLocale = 'fa';
  static const List<String> supportedLocales = ['fa', 'en'];
  
  // Animation
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
}
