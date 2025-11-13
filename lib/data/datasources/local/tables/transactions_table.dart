import 'package:drift/drift.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/data/datasources/local/tables/accounts_table.dart';
import 'package:financial_management/domain/entities/transaction.dart';

/// Transactions table definition
class Transactions extends Table {
  TextColumn get id => text()();
  IntColumn get amount => integer()();
  IntColumn get type => intEnum<TransactionType>()();
  TextColumn get accountId => text().customConstraint('REFERENCES accounts(id) ON DELETE CASCADE')();
  DateTimeColumn get dateTime => dateTime()();
  IntColumn get category => intEnum<TransactionCategory>()();
  TextColumn get note => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get smsId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
  
  @override
  List<Set<Column>> get uniqueKeys => [
    {smsId}, // Ensure SMS IDs are unique to prevent duplicate imports
  ];
}

/// Extension to convert database data to domain entity
extension TransactionDataExtension on TransactionData {
  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      type: TransactionType.values[type],
      accountId: accountId,
      dateTime: dateTime,
      category: TransactionCategory.values[category],
      note: note,
      imagePath: imagePath,
      smsId: smsId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension to convert domain entity to database companion
extension TransactionEntityExtension on Transaction {
  TransactionsCompanion toCompanion() {
    return TransactionsCompanion(
      id: Value(id),
      amount: Value(amount),
      type: Value(type.index),
      accountId: Value(accountId),
      dateTime: Value(dateTime),
      category: Value(category.index),
      note: Value(note),
      imagePath: Value(imagePath),
      smsId: Value(smsId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
