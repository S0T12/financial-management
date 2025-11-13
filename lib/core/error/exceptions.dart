/// Base exception for the application
class AppException implements Exception {
  final String message;
  final dynamic cause;
  
  AppException(this.message, [this.cause]);
  
  @override
  String toString() => 'AppException: $message${cause != null ? ' ($cause)' : ''}';
}

/// Database exceptions
class DatabaseException extends AppException {
  DatabaseException(super.message, [super.cause]);
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException(super.message, [super.cause]);
}

/// Validation exceptions
class ValidationException extends AppException {
  ValidationException(super.message, [super.cause]);
}

/// Permission exceptions
class PermissionException extends AppException {
  PermissionException(super.message, [super.cause]);
}

/// File exceptions
class FileException extends AppException {
  FileException(super.message, [super.cause]);
}

/// Authentication exceptions
class AuthenticationException extends AppException {
  AuthenticationException(super.message, [super.cause]);
}

/// SMS parsing exceptions
class SmsParsingException extends AppException {
  SmsParsingException(super.message, [super.cause]);
}
