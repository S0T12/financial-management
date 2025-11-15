import 'package:drift/drift.dart';

/// Junction table for many-to-many relationship between transactions and labels
@DataClassName('TransactionLabelMappingModel')
class TransactionLabelMappings extends Table {
  TextColumn get transactionId => text().customConstraint('NOT NULL REFERENCES transactions(id) ON DELETE CASCADE')();
  TextColumn get labelId => text().customConstraint('NOT NULL REFERENCES transaction_labels(id) ON DELETE CASCADE')();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {transactionId, labelId};
}
