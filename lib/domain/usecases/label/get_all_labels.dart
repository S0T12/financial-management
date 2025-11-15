import 'package:dartz/dartz.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transaction_label.dart';
import 'package:financial_management/domain/repositories/transaction_label_repository.dart';

/// Use case for getting all transaction labels
class GetAllLabels implements UseCase<List<TransactionLabel>, NoParams> {
  final TransactionLabelRepository repository;
  
  GetAllLabels(this.repository);
  
  @override
  Future<Either<Failure, List<TransactionLabel>>> call(NoParams params) {
    return repository.getAllLabels();
  }
}
