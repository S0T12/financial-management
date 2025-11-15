import 'package:dartz/dartz.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/domain/entities/transaction_label.dart';

/// Repository interface for transaction label operations
abstract class TransactionLabelRepository {
  /// Create a new label
  Future<Either<Failure, TransactionLabel>> createLabel({
    required String name,
    String? color,
    String? icon,
  });
  
  /// Get label by ID
  Future<Either<Failure, TransactionLabel>> getLabelById(String id);
  
  /// Get all labels
  Future<Either<Failure, List<TransactionLabel>>> getAllLabels();
  
  /// Update label
  Future<Either<Failure, TransactionLabel>> updateLabel(TransactionLabel label);
  
  /// Delete label
  Future<Either<Failure, void>> deleteLabel(String id);
}
