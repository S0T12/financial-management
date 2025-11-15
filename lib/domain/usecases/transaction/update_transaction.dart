import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';

class UpdateTransactionParams extends Equatable {
  final Transaction transaction;
  
  const UpdateTransactionParams({
    required this.transaction,
  });
  
  @override
  List<Object?> get props => [transaction];
}

/// Use case for updating a transaction
class UpdateTransaction implements UseCase<Transaction, UpdateTransactionParams> {
  final TransactionRepository repository;
  
  UpdateTransaction(this.repository);
  
  @override
  Future<Either<Failure, Transaction>> call(UpdateTransactionParams params) {
    return repository.updateTransaction(params.transaction);
  }
}
