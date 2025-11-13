import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/report.dart';
import 'package:financial_management/domain/repositories/report_repository.dart';

class GetMonthlyReportParams extends Equatable {
  final DateTime month;
  final String? accountId;
  
  const GetMonthlyReportParams({
    required this.month,
    this.accountId,
  });
  
  @override
  List<Object?> get props => [month, accountId];
}

/// Use case for getting monthly expense report
class GetMonthlyReport implements UseCase<MonthlyReport, GetMonthlyReportParams> {
  final ReportRepository repository;
  
  GetMonthlyReport(this.repository);
  
  @override
  Future<Either<Failure, MonthlyReport>> call(GetMonthlyReportParams params) {
    return repository.getMonthlyReport(
      month: params.month,
      accountId: params.accountId,
    );
  }
}
