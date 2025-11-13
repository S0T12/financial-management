import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/account.dart';
import 'package:financial_management/domain/repositories/account_repository.dart';

class CreateAccountParams extends Equatable {
  final String name;
  final AccountType type;
  final int initialBalance;
  final String? description;
  final String? color;
  
  const CreateAccountParams({
    required this.name,
    required this.type,
    this.initialBalance = 0,
    this.description,
    this.color,
  });
  
  @override
  List<Object?> get props => [name, type, initialBalance, description, color];
}

/// Use case for creating a new account
class CreateAccount implements UseCase<Account, CreateAccountParams> {
  final AccountRepository repository;
  
  CreateAccount(this.repository);
  
  @override
  Future<Either<Failure, Account>> call(CreateAccountParams params) {
    return repository.createAccount(
      name: params.name,
      type: params.type,
      initialBalance: params.initialBalance,
      description: params.description,
      color: params.color,
    );
  }
}
