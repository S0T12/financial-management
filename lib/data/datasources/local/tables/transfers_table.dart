import 'package:drift/drift.dart';
import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/data/datasources/local/tables/accounts_table.dart';
import 'package:financial_management/domain/entities/transfer.dart';

/// Transfers table definition
@DataClassName('TransferModel')
class Transfers extends Table {
  TextColumn get id => text()();
  TextColumn get fromAccountId => text().customConstraint('NOT NULL REFERENCES accounts(id) ON DELETE CASCADE')();
  TextColumn get toAccountId => text().customConstraint('NOT NULL REFERENCES accounts(id) ON DELETE CASCADE')();
  IntColumn get amount => integer()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get transferDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Extension to convert database model to domain entity
extension TransferModelExtension on TransferModel {
  Transfer toEntity() {
    return Transfer(
      id: id,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amount: amount,
      note: note,
      dateTime: transferDate,
      createdAt: createdAt,
    );
  }
}
