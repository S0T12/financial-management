import 'package:dartz/dartz.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/domain/entities/transaction.dart';

/// Repository interface for transaction operations
abstract class TransactionRepository {
  /// Create a new transaction
  Future<Either<Failure, Transaction>> createTransaction({
    required int amount,
    required TransactionType type,
    required String accountId,
    required DateTime dateTime,
    required TransactionCategory category,
    String? note,
    String? imagePath,
    String? smsId,
    List<String>? labelIds,
  });
  
  /// Get transaction by ID
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  
  /// Get all transactions with optional filters
  Future<Either<Failure, List<Transaction>>> getTransactions({
    String? accountId,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });
  
  /// Get transactions for a specific account
  Future<Either<Failure, List<Transaction>>> getAccountTransactions(
    String accountId, {
    int? limit,
    int? offset,
  });
  
  /// Update transaction
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);
  
  /// Delete transaction
  Future<Either<Failure, void>> deleteTransaction(String id);
  
  /// Get recent transactions
  Future<Either<Failure, List<Transaction>>> getRecentTransactions(int limit);
  
  /// Get transactions by SMS ID
  Future<Either<Failure, Transaction?>> getTransactionBySmsId(String smsId);
  
  /// Get total income for date range
  Future<Either<Failure, int>> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
  });
  
  /// Get total expense for date range
  Future<Either<Failure, int>> getTotalExpense({
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
  });
  
  /// Search transactions
  Future<Either<Failure, List<Transaction>>> searchTransactions(String query);
}
