import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transfer.dart';
import 'package:financial_management/domain/repositories/account_repository.dart';
import 'package:financial_management/domain/repositories/transfer_repository.dart';

class CreateTransferParams extends Equatable {
  final String fromAccountId;
  final String toAccountId;
  final int amount;
  final String? note;
  final DateTime? dateTime;
  
  const CreateTransferParams({
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    this.note,
    this.dateTime,
  });
  
  @override
  List<Object?> get props => [fromAccountId, toAccountId, amount, note, dateTime];
}

/// Use case for creating a transfer between accounts
class CreateTransfer implements UseCase<Transfer, CreateTransferParams> {
  final TransferRepository transferRepository;
  final AccountRepository accountRepository;
  
  CreateTransfer(this.transferRepository, this.accountRepository);
  
  @override
  Future<Either<Failure, Transfer>> call(CreateTransferParams params) async {
    // Validate accounts exist
    final fromAccountResult = await accountRepository.accountExists(params.fromAccountId);
    if (fromAccountResult.isLeft()) {
      return Left(fromAccountResult.fold((l) => l, (r) => const ValidationFailure('Invalid account')));
    }
    
    final toAccountResult = await accountRepository.accountExists(params.toAccountId);
    if (toAccountResult.isLeft()) {
      return Left(toAccountResult.fold((l) => l, (r) => const ValidationFailure('Invalid account')));
    }
    
    // Validate amount is positive
    if (params.amount <= 0) {
      return const Left(ValidationFailure('Transfer amount must be positive'));
    }
    
    // Validate different accounts
    if (params.fromAccountId == params.toAccountId) {
      return const Left(ValidationFailure('Cannot transfer to the same account'));
    }
    
    // Create transfer
    return transferRepository.createTransfer(
      fromAccountId: params.fromAccountId,
      toAccountId: params.toAccountId,
      amount: params.amount,
      note: params.note,
      dateTime: params.dateTime,
    );
  }
}
