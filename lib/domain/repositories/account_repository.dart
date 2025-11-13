import 'package:dartz/dartz.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/domain/entities/account.dart';

/// Repository interface for account operations
abstract class AccountRepository {
  /// Create a new account
  Future<Either<Failure, Account>> createAccount({
    required String name,
    required AccountType type,
    int initialBalance = 0,
    String? description,
    String? color,
  });
  
  /// Get account by ID
  Future<Either<Failure, Account>> getAccountById(String id);
  
  /// Get all accounts
  Future<Either<Failure, List<Account>>> getAllAccounts();
  
  /// Update account
  Future<Either<Failure, Account>> updateAccount(Account account);
  
  /// Delete account
  Future<Either<Failure, void>> deleteAccount(String id);
  
  /// Update account balance
  Future<Either<Failure, Account>> updateAccountBalance(String id, int newBalance);
  
  /// Get total balance across all accounts
  Future<Either<Failure, int>> getTotalBalance();
  
  /// Check if account exists
  Future<Either<Failure, bool>> accountExists(String id);
}
