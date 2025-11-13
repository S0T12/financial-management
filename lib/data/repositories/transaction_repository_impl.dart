import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/exceptions.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/data/datasources/local/tables/transactions_table.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of TransactionRepository
class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase database;
  final Uuid uuid;
  
  TransactionRepositoryImpl(this.database, this.uuid);
  
  @override
  Future<Either<Failure, Transaction>> createTransaction({
    required int amount,
    required TransactionType type,
    required String accountId,
    required DateTime dateTime,
    required TransactionCategory category,
    String? note,
    String? imagePath,
    String? smsId,
  }) async {
    try {
      final now = DateTime.now();
      final transaction = Transaction(
        id: uuid.v4(),
        amount: amount,
        type: type,
        accountId: accountId,
        dateTime: dateTime,
        category: category,
        note: note,
        imagePath: imagePath,
        smsId: smsId,
        createdAt: now,
        updatedAt: now,
      );
      
      await database.into(database.transactions).insert(transaction.toCompanion());
      
      return Right(transaction);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create transaction: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final query = database.select(database.transactions)
        ..where((tbl) => tbl.id.equals(id));
      
      final result = await query.getSingleOrNull();
      
      if (result == null) {
        return const Left(DatabaseFailure('Transaction not found'));
      }
      
      return Right(result.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get transaction: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getTransactions({
    String? accountId,
    TransactionType? type,
    TransactionCategory? category,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    try {
      final query = database.select(database.transactions);
      
      if (accountId != null) {
        query.where((tbl) => tbl.accountId.equals(accountId));
      }
      if (type != null) {
        query.where((tbl) => tbl.type.equals(type.index));
      }
      if (category != null) {
        query.where((tbl) => tbl.category.equals(category.index));
      }
      if (startDate != null) {
        query.where((tbl) => tbl.dateTime.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where((tbl) => tbl.dateTime.isSmallerOrEqualValue(endDate));
      }
      
      query.orderBy([
        (tbl) => OrderingTerm(expression: tbl.dateTime, mode: OrderingMode.desc)
      ]);
      
      if (limit != null) {
        query.limit(limit, offset: offset);
      }
      
      final results = await query.get();
      final transactions = results.map((data) => data.toEntity()).toList();
      
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get transactions: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getAccountTransactions(
    String accountId, {
    int? limit,
    int? offset,
  }) async {
    return getTransactions(
      accountId: accountId,
      limit: limit,
      offset: offset,
    );
  }
  
  @override
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction) async {
    try {
      final updated = transaction.copyWith(updatedAt: DateTime.now());
      
      await database.update(database.transactions).replace(updated.toCompanion());
      
      return Right(updated);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to update transaction: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      await (database.delete(database.transactions)
        ..where((tbl) => tbl.id.equals(id))).go();
      
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete transaction: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> getRecentTransactions(int limit) async {
    return getTransactions(limit: limit);
  }
  
  @override
  Future<Either<Failure, Transaction?>> getTransactionBySmsId(String smsId) async {
    try {
      final query = database.select(database.transactions)
        ..where((tbl) => tbl.smsId.equals(smsId));
      
      final result = await query.getSingleOrNull();
      
      return Right(result?.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get transaction by SMS ID: $e'));
    }
  }
  
  @override
  Future<Either<Failure, int>> getTotalIncome({
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
  }) async {
    try {
      final query = database.selectOnly(database.transactions)
        ..addColumns([database.transactions.amount.sum()])
        ..where(database.transactions.type.equals(TransactionType.income.index));
      
      if (accountId != null) {
        query.where(database.transactions.accountId.equals(accountId));
      }
      if (startDate != null) {
        query.where(database.transactions.dateTime.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where(database.transactions.dateTime.isSmallerOrEqualValue(endDate));
      }
      
      final result = await query.getSingle();
      final total = result.read(database.transactions.amount.sum()) ?? 0;
      
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get total income: $e'));
    }
  }
  
  @override
  Future<Either<Failure, int>> getTotalExpense({
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
  }) async {
    try {
      final query = database.selectOnly(database.transactions)
        ..addColumns([database.transactions.amount.sum()])
        ..where(database.transactions.type.equals(TransactionType.expense.index));
      
      if (accountId != null) {
        query.where(database.transactions.accountId.equals(accountId));
      }
      if (startDate != null) {
        query.where(database.transactions.dateTime.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where(database.transactions.dateTime.isSmallerOrEqualValue(endDate));
      }
      
      final result = await query.getSingle();
      final total = result.read(database.transactions.amount.sum()) ?? 0;
      
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get total expense: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Transaction>>> searchTransactions(String query) async {
    try {
      final search = database.select(database.transactions)
        ..where((tbl) => tbl.note.contains(query))
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.dateTime, mode: OrderingMode.desc)
        ]);
      
      final results = await search.get();
      final transactions = results.map((data) => data.toEntity()).toList();
      
      return Right(transactions);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to search transactions: $e'));
    }
  }
}
