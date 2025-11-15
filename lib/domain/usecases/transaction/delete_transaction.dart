import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';

class DeleteTransactionParams extends Equatable {
  final String id;
  
  const DeleteTransactionParams({
    required this.id,
  });
  
  @override
  List<Object?> get props => [id];
}

/// Use case for deleting a transaction
class DeleteTransaction implements UseCase<void, DeleteTransactionParams> {
  final TransactionRepository repository;
  
  DeleteTransaction(this.repository);
  
  @override
  Future<Either<Failure, void>> call(DeleteTransactionParams params) {
    return repository.deleteTransaction(params.id);
  }
}
