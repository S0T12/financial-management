import 'package:drift/drift.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/domain/entities/account.dart';

/// Accounts table definition
@DataClassName('AccountModel')
class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get type => intEnum<AccountType>()();
  IntColumn get balance => integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Extension to convert database model to domain entity
extension AccountModelExtension on AccountModel {
  Account toEntity() {
    return Account(
      id: id,
      name: name,
      type: type,
      balance: balance,
      description: description,
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
