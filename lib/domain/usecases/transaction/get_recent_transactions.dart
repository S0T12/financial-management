import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';

/// Use case to get recent transactions
class GetRecentTransactions implements UseCase<List<Transaction>, GetRecentTransactionsParams> {
  final TransactionRepository repository;

  GetRecentTransactions(this.repository);

  @override
  Future<Either<Failure, List<Transaction>>> call(GetRecentTransactionsParams params) async {
    return await repository.getRecentTransactions(params.limit);
  }
}

/// Parameters for GetRecentTransactions use case
class GetRecentTransactionsParams extends Equatable {
  final int limit;

  const GetRecentTransactionsParams({required this.limit});

  @override
  List<Object?> get props => [limit];
}
