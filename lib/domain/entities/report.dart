import 'package:equatable/equatable.dart';
import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/domain/entities/transaction.dart';

/// Category spending data for reports
class CategorySpending extends Equatable {
  final TransactionCategory category;
  final int totalAmount;
  final int transactionCount;
  final double percentage;
  
  const CategorySpending({
    required this.category,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentage,
  });
  
  @override
  List<Object> get props => [category, totalAmount, transactionCount, percentage];
}

/// Daily spending data for time-series charts
class DailySpending extends Equatable {
  final DateTime date;
  final int incomeAmount;
  final int expenseAmount;
  final int balance;
  
  const DailySpending({
    required this.date,
    required this.incomeAmount,
    required this.expenseAmount,
    required this.balance,
  });
  
  int get netAmount => incomeAmount - expenseAmount;
  
  @override
  List<Object> get props => [date, incomeAmount, expenseAmount, balance];
}

/// Monthly report summary
class MonthlyReport extends Equatable {
  final DateTime month;
  final int totalIncome;
  final int totalExpense;
  final int balance;
  final List<CategorySpending> categoryBreakdown;
  final List<DailySpending> dailyData;
  final double averageDailySpending;
  
  const MonthlyReport({
    required this.month,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
    required this.categoryBreakdown,
    required this.dailyData,
    required this.averageDailySpending,
  });
  
  int get netAmount => totalIncome - totalExpense;
  
  @override
  List<Object> get props => [
    month,
    totalIncome,
    totalExpense,
    balance,
    categoryBreakdown,
    dailyData,
    averageDailySpending,
  ];
}

/// Report filter parameters
class ReportFilter extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<TransactionType>? types;
  final List<String>? accountIds;
  final List<String>? categoryNames;
  final List<String>? labelIds;
  final int? minAmount;
  final int? maxAmount;
  
  const ReportFilter({
    this.startDate,
    this.endDate,
    this.types,
    this.accountIds,
    this.categoryNames,
    this.labelIds,
    this.minAmount,
    this.maxAmount,
  });
  
  ReportFilter copyWith({
    DateTime? startDate,
    DateTime? endDate,
    List<TransactionType>? types,
    List<String>? accountIds,
    List<String>? categoryNames,
    List<String>? labelIds,
    int? minAmount,
    int? maxAmount,
  }) {
    return ReportFilter(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      types: types ?? this.types,
      accountIds: accountIds ?? this.accountIds,
      categoryNames: categoryNames ?? this.categoryNames,
      labelIds: labelIds ?? this.labelIds,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }
  
  @override
  List<Object?> get props => [
    startDate,
    endDate,
    types,
    accountIds,
    categoryNames,
    labelIds,
    minAmount,
    maxAmount,
  ];
}

/// Advanced report data containing statistics and transactions
class AdvancedReportData extends Equatable {
  final int totalIncome;
  final int totalExpense;
  final int netAmount;
  final int transactionCount;
  final Map<String, int> categoryBreakdown;
  final Map<String, int> accountBreakdown;
  final Map<String, int> labelBreakdown;
  final Map<String, int> dailyTrend;
  final List<Transaction> transactions;
  
  const AdvancedReportData({
    required this.totalIncome,
    required this.totalExpense,
    required this.netAmount,
    required this.transactionCount,
    required this.categoryBreakdown,
    required this.accountBreakdown,
    required this.labelBreakdown,
    required this.dailyTrend,
    required this.transactions,
  });
  
  @override
  List<Object?> get props => [
    totalIncome,
    totalExpense,
    netAmount,
    transactionCount,
    categoryBreakdown,
    accountBreakdown,
    labelBreakdown,
    dailyTrend,
    transactions,
  ];
}
