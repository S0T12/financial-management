import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/exceptions.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/data/datasources/local/tables/transactions_table.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';
import 'package:financial_management/domain/repositories/account_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of TransactionRepository
class TransactionRepositoryImpl implements TransactionRepository {
  final AppDatabase database;
  final Uuid uuid;
  final AccountRepository accountRepository;
  
  TransactionRepositoryImpl(this.database, this.uuid, this.accountRepository);
  
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
    List<String>? labelIds,
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
        labelIds: labelIds,
        createdAt: now,
        updatedAt: now,
      );
      
      // Insert transaction
      await database.into(database.transactions).insert(
        TransactionsCompanion(
          id: Value(transaction.id),
          amount: Value(transaction.amount),
          type: Value(transaction.type),
          accountId: Value(transaction.accountId),
          transactionDate: Value(transaction.dateTime),
          category: Value(transaction.category),
          note: Value(transaction.note),
          imagePath: Value(transaction.imagePath),
          smsId: Value(transaction.smsId),
          createdAt: Value(transaction.createdAt),
          updatedAt: Value(transaction.updatedAt),
        ),
      );
      
      // Insert label mappings if labels are provided
      if (labelIds != null && labelIds.isNotEmpty) {
        for (final labelId in labelIds) {
          await database.into(database.transactionLabelMappings).insert(
            TransactionLabelMappingsCompanion(
              transactionId: Value(transaction.id),
              labelId: Value(labelId),
              createdAt: Value(now),
            ),
          );
        }
      }
      
      // Update account balance
      await _updateAccountBalanceForTransaction(transaction, isCreating: true);
      
      return Right(transaction);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create transaction: $e'));
    }
  }
  
  Future<void> _updateAccountBalanceForTransaction(Transaction transaction, {required bool isCreating}) async {
    final accountResult = await accountRepository.getAccountById(transaction.accountId);
    
    await accountResult.fold(
      (failure) async {
        // Account not found, skip balance update
      },
      (account) async {
        int newBalance = account.balance;
        
        if (isCreating) {
          // Creating new transaction
          if (transaction.type == TransactionType.expense) {
            newBalance -= transaction.amount;
          } else {
            newBalance += transaction.amount;
          }
        } else {
          // Deleting transaction (reverse the operation)
          if (transaction.type == TransactionType.expense) {
            newBalance += transaction.amount;
          } else {
            newBalance -= transaction.amount;
          }
        }
        
        await accountRepository.updateAccountBalance(transaction.accountId, newBalance);
      },
    );
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
      
      // Get label IDs for this transaction
      final labelQuery = database.select(database.transactionLabelMappings)
        ..where((tbl) => tbl.transactionId.equals(id));
      final labelMappings = await labelQuery.get();
      final labelIds = labelMappings.map((m) => m.labelId).toList();
      
      final transaction = result.toEntity().copyWith(labelIds: labelIds.isEmpty ? null : labelIds);
      
      return Right(transaction);
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
        query.where((tbl) => tbl.transactionDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where((tbl) => tbl.transactionDate.isSmallerOrEqualValue(endDate));
      }
      
      query.orderBy([
        (tbl) => OrderingTerm(expression: tbl.transactionDate, mode: OrderingMode.desc)
      ]);
      
      if (limit != null) {
        query.limit(limit, offset: offset);
      }
      
      final results = await query.get();
      
      // Get labels for each transaction
      final transactions = <Transaction>[];
      for (final result in results) {
        final labelQuery = database.select(database.transactionLabelMappings)
          ..where((tbl) => tbl.transactionId.equals(result.id));
        final labelMappings = await labelQuery.get();
        final labelIds = labelMappings.map((m) => m.labelId).toList();
        
        transactions.add(result.toEntity().copyWith(labelIds: labelIds.isEmpty ? null : labelIds));
      }
      
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
      
      // Update the transaction
      await database.update(database.transactions).replace(
        TransactionsCompanion(
          id: Value(updated.id),
          amount: Value(updated.amount),
          type: Value(updated.type),
          accountId: Value(updated.accountId),
          transactionDate: Value(updated.dateTime),
          category: Value(updated.category),
          note: Value(updated.note),
          imagePath: Value(updated.imagePath),
          smsId: Value(updated.smsId),
          createdAt: Value(updated.createdAt),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      
      // Update label mappings
      // First delete all existing mappings
      await (database.delete(database.transactionLabelMappings)
        ..where((tbl) => tbl.transactionId.equals(updated.id))).go();
      
      // Then insert new mappings
      if (updated.labelIds != null && updated.labelIds!.isNotEmpty) {
        for (final labelId in updated.labelIds!) {
          await database.into(database.transactionLabelMappings).insert(
            TransactionLabelMappingsCompanion(
              transactionId: Value(updated.id),
              labelId: Value(labelId),
              createdAt: Value(DateTime.now()),
            ),
          );
        }
      }
      
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
      // Get transaction first to update account balance
      final transactionResult = await getTransactionById(id);
      
      await transactionResult.fold(
        (failure) async {
          // Transaction not found
        },
        (transaction) async {
          // Update account balance (reverse the transaction)
          await _updateAccountBalanceForTransaction(transaction, isCreating: false);
        },
      );
      
      // Delete label mappings (cascade will handle this, but explicit is better)
      await (database.delete(database.transactionLabelMappings)
        ..where((tbl) => tbl.transactionId.equals(id))).go();
      
      // Delete the transaction
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
        query.where(database.transactions.transactionDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where(database.transactions.transactionDate.isSmallerOrEqualValue(endDate));
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
        query.where(database.transactions.transactionDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where(database.transactions.transactionDate.isSmallerOrEqualValue(endDate));
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
          (tbl) => OrderingTerm(expression: tbl.transactionDate, mode: OrderingMode.desc)
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
