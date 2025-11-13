import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

/// Database operation failures
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// File operation failures
class FileFailure extends Failure {
  const FileFailure(super.message);
}

/// Authentication failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure(super.message);
}

/// SMS parsing failures
class SmsParsingFailure extends Failure {
  const SmsParsingFailure(super.message);
}
