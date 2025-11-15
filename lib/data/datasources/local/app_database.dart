import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:financial_management/core/constants/app_constants.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/data/datasources/local/tables/accounts_table.dart';
import 'package:financial_management/data/datasources/local/tables/transactions_table.dart';
import 'package:financial_management/data/datasources/local/tables/transfers_table.dart';
import 'package:financial_management/data/datasources/local/tables/transaction_labels_table.dart';
import 'package:financial_management/data/datasources/local/tables/transaction_label_mapping_table.dart';
import 'package:financial_management/domain/entities/transaction.dart' as domain;

part 'app_database.g.dart';

/// Main database class for the application
@DriftDatabase(tables: [Accounts, Transactions, Transfers, TransactionLabels, TransactionLabelMappings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  
  @override
  int get schemaVersion => 2;
  
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle database migrations here
        if (from < 2) {
          // Example migration for future versions
          // await m.addColumn(accounts, accounts.newColumn);
        }
      },
    );
  }
}

/// Open database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseName));
    return NativeDatabase(file);
  });
}
