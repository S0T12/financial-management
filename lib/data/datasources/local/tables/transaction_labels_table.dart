import 'package:drift/drift.dart';
import 'package:financial_management/domain/entities/transaction_label.dart';

/// Transaction Labels table definition
@DataClassName('TransactionLabelModel')
class TransactionLabels extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get color => text().nullable()();
  TextColumn get icon => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

/// Extension to convert database model to domain entity
extension TransactionLabelModelExtension on TransactionLabelModel {
  TransactionLabel toEntity() {
    return TransactionLabel(
      id: id,
      name: name,
      color: color,
      icon: icon,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
