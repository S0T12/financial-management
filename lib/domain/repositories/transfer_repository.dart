import 'package:dartz/dartz.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/domain/entities/transfer.dart';

/// Repository interface for transfer operations
abstract class TransferRepository {
  /// Create a new transfer between accounts
  Future<Either<Failure, Transfer>> createTransfer({
    required String fromAccountId,
    required String toAccountId,
    required int amount,
    String? note,
    DateTime? dateTime,
  });
  
  /// Get transfer by ID
  Future<Either<Failure, Transfer>> getTransferById(String id);
  
  /// Get all transfers
  Future<Either<Failure, List<Transfer>>> getAllTransfers({
    String? accountId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });
  
  /// Get transfers for a specific account (incoming or outgoing)
  Future<Either<Failure, List<Transfer>>> getAccountTransfers(String accountId);
  
  /// Delete transfer
  Future<Either<Failure, void>> deleteTransfer(String id);
}
