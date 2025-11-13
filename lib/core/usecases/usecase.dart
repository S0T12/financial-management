import 'package:dartz/dartz.dart';
import 'package:financial_management/core/error/failures.dart';

/// Base class for all use cases in the application
/// Follows the single responsibility principle
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// For use cases that don't require parameters
class NoParams {
  const NoParams();
}
