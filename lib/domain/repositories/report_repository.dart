import 'package:dartz/dartz.dart';
import 'package:financial_management/core/error/failures.dart';
import 'package:financial_management/domain/entities/report.dart';

/// Repository interface for analytics and reporting
abstract class ReportRepository {
  /// Get monthly report for a specific month
  Future<Either<Failure, MonthlyReport>> getMonthlyReport({
    required DateTime month,
    String? accountId,
  });
  
  /// Get category spending breakdown
  Future<Either<Failure, List<CategorySpending>>> getCategorySpending({
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
  });
  
  /// Get daily spending data
  Future<Either<Failure, List<DailySpending>>> getDailySpending({
    required DateTime startDate,
    required DateTime endDate,
    String? accountId,
  });
  
  /// Get average daily spending
  Future<Either<Failure, double>> getAverageDailySpending({
    DateTime? startDate,
    DateTime? endDate,
    String? accountId,
  });
  
  /// Get spending trend (percentage change from previous period)
  Future<Either<Failure, double>> getSpendingTrend({
    required DateTime currentStartDate,
    required DateTime currentEndDate,
    String? accountId,
  });
}
