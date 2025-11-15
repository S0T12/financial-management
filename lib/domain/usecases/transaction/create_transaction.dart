import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';

class CreateTransactionParams extends Equatable {
  final int amount;
  final TransactionType type;
  final String accountId;
  final DateTime dateTime;
  final TransactionCategory category;
  final String? note;
  final String? imagePath;
  final String? smsId;
  final List<String>? labelIds;
  
  const CreateTransactionParams({
    required this.amount,
    required this.type,
    required this.accountId,
    required this.dateTime,
    required this.category,
    this.note,
    this.imagePath,
    this.smsId,
    this.labelIds,
  });
  
  @override
  List<Object?> get props => [
    amount,
    type,
    accountId,
    dateTime,
    category,
    note,
    imagePath,
    smsId,
    labelIds,
  ];
}

/// Use case for creating a new transaction
class CreateTransaction implements UseCase<Transaction, CreateTransactionParams> {
  final TransactionRepository repository;
  
  CreateTransaction(this.repository);
  
  @override
  Future<Either<Failure, Transaction>> call(CreateTransactionParams params) {
    return repository.createTransaction(
      amount: params.amount,
      type: params.type,
      accountId: params.accountId,
      dateTime: params.dateTime,
      category: params.category,
      note: params.note,
      imagePath: params.imagePath,
      smsId: params.smsId,
      labelIds: params.labelIds,
    );
  }
}
