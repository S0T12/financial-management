import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/data/datasources/local/app_database.dart';
import 'package:financial_management/data/datasources/local/tables/transaction_labels_table.dart';
import 'package:financial_management/domain/entities/transaction_label.dart';
import 'package:financial_management/domain/repositories/transaction_label_repository.dart';
import 'package:uuid/uuid.dart';

/// Implementation of TransactionLabelRepository
class TransactionLabelRepositoryImpl implements TransactionLabelRepository {
  final AppDatabase database;
  final Uuid uuid;
  
  TransactionLabelRepositoryImpl(this.database, this.uuid);
  
  @override
  Future<Either<Failure, TransactionLabel>> createLabel({
    required String name,
    String? color,
    String? icon,
  }) async {
    try {
      final now = DateTime.now();
      final label = TransactionLabel(
        id: uuid.v4(),
        name: name,
        color: color,
        icon: icon,
        createdAt: now,
        updatedAt: now,
      );
      
      await database.into(database.transactionLabels).insert(
        TransactionLabelsCompanion(
          id: Value(label.id),
          name: Value(label.name),
          color: Value(label.color),
          icon: Value(label.icon),
          createdAt: Value(label.createdAt),
          updatedAt: Value(label.updatedAt),
        ),
      );
      
      return Right(label);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to create label: $e'));
    }
  }
  
  @override
  Future<Either<Failure, TransactionLabel>> getLabelById(String id) async {
    try {
      final query = database.select(database.transactionLabels)
        ..where((tbl) => tbl.id.equals(id));
      
      final result = await query.getSingleOrNull();
      
      if (result == null) {
        return const Left(DatabaseFailure('Label not found'));
      }
      
      return Right(result.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get label: $e'));
    }
  }
  
  @override
  Future<Either<Failure, List<TransactionLabel>>> getAllLabels() async {
    try {
      final query = database.select(database.transactionLabels)
        ..orderBy([
          (tbl) => OrderingTerm(expression: tbl.name, mode: OrderingMode.asc)
        ]);
      
      final results = await query.get();
      final labels = results.map((model) => model.toEntity()).toList();
      
      return Right(labels);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to get labels: $e'));
    }
  }
  
  @override
  Future<Either<Failure, TransactionLabel>> updateLabel(TransactionLabel label) async {
    try {
      final updated = label.copyWith(updatedAt: DateTime.now());
      
      await database.update(database.transactionLabels).replace(
        TransactionLabelsCompanion(
          id: Value(updated.id),
          name: Value(updated.name),
          color: Value(updated.color),
          icon: Value(updated.icon),
          createdAt: Value(updated.createdAt),
          updatedAt: Value(updated.updatedAt),
        ),
      );
      
      return Right(updated);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to update label: $e'));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteLabel(String id) async {
    try {
      // Delete label mappings first
      await (database.delete(database.transactionLabelMappings)
        ..where((tbl) => tbl.labelId.equals(id))).go();
      
      // Delete the label
      await (database.delete(database.transactionLabels)
        ..where((tbl) => tbl.id.equals(id))).go();
      
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(DatabaseFailure('Failed to delete label: $e'));
    }
  }
}
