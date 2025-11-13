import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/error/exceptions.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/data/datasources/local/tables/accounts_table.dart';
import 'package:financial_management/domain/entities/account.dart';
import 'package:financial_management/domain/repositories/account_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of AccountRepository
class AccountRepositoryImpl implements AccountRepository {
  final AppDatabase database;
  final Uuid uuid;
  
  AccountRepositoryImpl(this.database, this.uuid);
  
  @override
  Future<Either<Failure, Account>> createAccount({
    required String name,
    required AccountType type,
    int initialBalance = 0,
    String? description,
    String? color,
  }) async {
    try {
      final now = DateTime.now();
      final account = Account(
        id: uuid.v4(),
        name: name,
        type: type,
        balance: initialBalance,
        description: description,
        color: color,
        createdAt: now,
        updatedAt: now,
      );
      
      await database.into(database.accounts).insert(
        AccountsCompanion(
          id: Value(account.id),
          name: Value(account.name),
          type: Value(account.type),
          balance: Value(account.balance),
          description: Value(account.description),
          color: Value(account.color),
          createdAt: Value(account.createdAt),
          updatedAt: Value(account.updatedAt),
        ),
      );
      
      return Right(account);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create account: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Account>> getAccountById(String id) async {
    try {
      final query = database.select(database.accounts)
        ..where((tbl) => tbl.id.equals(id));
      
      final result = await query.getSingleOrNull();
      
      if (result == null) {
        return const Left(DatabaseFailure('Account not found'));
      }
      
      return Right(result.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get account: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<Account>>> getAllAccounts() async {
    try {
      final query = database.select(database.accounts)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.createdAt, mode: OrderingMode.desc)
        ]);
      
      final results = await query.get();
      final accounts = results.map((model) => model.toEntity()).toList();
      
      return Right(accounts);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get accounts: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Account>> updateAccount(Account account) async {
    try {
      final updated = account.copyWith(updatedAt: DateTime.now());
      
      await database.update(database.accounts).replace(
        AccountsCompanion(
          id: Value(updated.id),
          name: Value(updated.name),
          type: Value(updated.type),
          balance: Value(updated.balance),
          description: Value(updated.description),
          color: Value(updated.color),
          createdAt: Value(updated.createdAt),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      
      return Right(updated);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to update account: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteAccount(String id) async {
    try {
      await (database.delete(database.accounts)
        ..where((tbl) => tbl.id.equals(id))).go();
      
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete account: $e'));
    }
  }
  
  @override
  Future<Either<Failure, Account>> updateAccountBalance(String id, int newBalance) async {
    try {
      final accountResult = await getAccountById(id);
      
      return accountResult.fold(
        (failure) => Left(failure),
        (account) async {
          final updated = account.copyWith(
            balance: newBalance,
            updatedAt: DateTime.now(),
          );
          return updateAccount(updated);
        },
      );
    } catch (e) {
      return Left(DatabaseFailure('Failed to update account balance: $e'));
    }
  }
  
  @override
  Future<Either<Failure, int>> getTotalBalance() async {
    try {
      final query = database.selectOnly(database.accounts)
        ..addColumns([database.accounts.balance.sum()]);
      
      final result = await query.getSingle();
      final total = result.read(database.accounts.balance.sum()) ?? 0;
      
      return Right(total);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get total balance: $e'));
    }
  }
  
  @override
  Future<Either<Failure, bool>> accountExists(String id) async {
    try {
      final query = database.select(database.accounts)
        ..where((tbl) => tbl.id.equals(id));
      
      final result = await query.getSingleOrNull();
      
      return Right(result != null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to check account existence: $e'));
    }
  }
}
