import 'package:equatable/equatable.dart';
import 'package:financial_management/core/constants/category_constants.dart';

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
