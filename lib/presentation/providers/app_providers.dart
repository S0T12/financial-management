import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/data/repositories/account_repository_impl.dart';
import 'package:financial_management/data/repositories/transaction_repository_impl.dart';
import 'package:financial_management/domain/repositories/account_repository.dart';
import 'package:financial_management/domain/repositories/transaction_repository.dart';
import 'package:financial_management/domain/usecases/account/create_account.dart';
import 'package:financial_management/domain/usecases/account/get_all_accounts.dart';
import 'package:financial_management/domain/usecases/transaction/create_transaction.dart';
import 'package:financial_management/domain/usecases/transaction/get_recent_transactions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Database
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// UUID
final uuidProvider = Provider<Uuid>((ref) {
  return const Uuid();
});

// Repositories
final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  return AccountRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(uuidProvider),
  );
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return TransactionRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(uuidProvider),
  );
});

// Use Cases
final getAllAccountsProvider = Provider<GetAllAccounts>((ref) {
  return GetAllAccounts(ref.watch(accountRepositoryProvider));
});

final createAccountProvider = Provider<CreateAccount>((ref) {
  return CreateAccount(ref.watch(accountRepositoryProvider));
});

final getRecentTransactionsProvider = Provider<GetRecentTransactions>((ref) {
  return GetRecentTransactions(ref.watch(transactionRepositoryProvider));
});

final createTransactionProvider = Provider<CreateTransaction>((ref) {
  return CreateTransaction(ref.watch(transactionRepositoryProvider));
});
