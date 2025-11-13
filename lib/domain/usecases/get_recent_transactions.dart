import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';

class GetRecentTransactionsParams extends Equatable {
  final int limit;
  
  const GetRecentTransactionsParams({this.limit = 10});
  
  @override
  List<Object> get props => [limit];
}

/// Use case for getting recent transactions
class GetRecentTransactions 
    implements UseCase<List<Transaction>, GetRecentTransactionsParams> {
  final TransactionRepository repository;
  
  GetRecentTransactions(this.repository);
  
  @override
  Future<Either<Failure, List<Transaction>>> call(GetRecentTransactionsParams params) {
    return repository.getRecentTransactions(params.limit);
  }
}
