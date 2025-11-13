import 'package:dartz/dartz.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/account.dart';
import 'package:financial_management/domain/repositories/account_repository.dart';

/// Use case to get all accounts
class GetAllAccounts implements UseCase<List<Account>, NoParams> {
  final AccountRepository repository;

  GetAllAccounts(this.repository);

  @override
  Future<Either<Failure, List<Account>>> call(NoParams params) async {
    return await repository.getAllAccounts();
  }
}
