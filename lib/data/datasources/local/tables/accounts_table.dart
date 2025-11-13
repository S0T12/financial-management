import 'package:drift/drift.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/domain/entities/account.dart';

/// Accounts table definition
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

/// Extension to convert database row to domain entity
extension AccountExtension on AccountsCompanion {
  Account toEntity() {
    return Account(
      id: id.value,
      name: name.value,
      type: AccountType.values[type.value],
      balance: balance.value,
      description: description.value,
      color: color.value,
      createdAt: createdAt.value,
      updatedAt: updatedAt.value,
    );
  }
}

/// Extension to convert domain entity to database companion
extension AccountEntityExtension on Account {
  AccountsCompanion toCompanion() {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type.index),
      balance: Value(balance),
      description: Value(description),
      color: Value(color),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }
}
