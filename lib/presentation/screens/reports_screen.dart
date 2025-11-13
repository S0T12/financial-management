import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/core/utils/date_time_utils.dart';
import 'package:financial_management/domain/entities/report.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/usecases/transaction/get_recent_transactions.dart';
import 'package:financial_management/presentation/providers/app_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  List<TransactionType> _selectedTypes = [TransactionType.income, TransactionType.expense];
  List<TransactionCategory> _selectedCategories = [];
  
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('reports')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _exportReport,
          ),
        ],
      ),
      body: FutureBuilder<AdvancedReportData>(
        future: _generateReport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('error_loading_report'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          
          final reportData = snapshot.data!;
          
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Date Range Display
              _buildDateRangeCard(locale),
              
              const SizedBox(height: 16),
              
              // Summary Cards
              _buildSummaryCards(reportData, locale),
              
              const SizedBox(height: 24),
              
              // Income vs Expense Chart
              _buildIncomeExpenseChart(reportData, context),
              
              const SizedBox(height: 24),
              
              // Category Breakdown
              _buildCategoryBreakdown(reportData, context, locale),
              
              const SizedBox(height: 24),
              
              // Daily Trend Chart
              _buildDailyTrendChart(reportData, context),
              
              const SizedBox(height: 24),
              
              // Account Breakdown
              if (reportData.accountBreakdown.isNotEmpty)
                _buildAccountBreakdown(reportData, context, locale),
              
              const SizedBox(height: 24),
              
              // Transactions List
              _buildTransactionsList(reportData, context, locale),
            ],
          );
        },
      ),
    );
  }
  
  Widget _buildDateRangeCard(String locale) {
    final dateFormat = DateFormat('yyyy/MM/dd');
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.tr('date_range'),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dateFormat.format(_startDate)} - ${dateFormat.format(_endDate)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: _selectDateRange,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryCards(AdvancedReportData data, String locale) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            context.tr('total_income'),
            data.totalIncome,
            Icons.arrow_downward,
            Colors.green,
            locale,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            context.tr('total_expense'),
            data.totalExpense,
            Icons.arrow_upward,
            Colors.red,
            locale,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            context.tr('net_amount'),
            data.netAmount,
            Icons.account_balance_wallet,
            data.netAmount >= 0 ? Colors.green : Colors.red,
            locale,
          ),
        ),
      ],
    );
  }
  
  Widget _buildSummaryCard(String title, int amount, IconData icon, Color color, String locale) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              NumberUtils.formatCurrency(amount.abs(), locale: locale),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildIncomeExpenseChart(AdvancedReportData data, BuildContext context) {
    if (data.totalIncome == 0 && data.totalExpense == 0) {
      return const SizedBox();
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('income_vs_expense'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                  sections: [
                    PieChartSectionData(
                      value: data.totalIncome.toDouble(),
                      title: '${((data.totalIncome / (data.totalIncome + data.totalExpense)) * 100).toStringAsFixed(1)}%',
                      color: Colors.green,
                      radius: 50,
                    ),
                    PieChartSectionData(
                      value: data.totalExpense.toDouble(),
                      title: '${((data.totalExpense / (data.totalIncome + data.totalExpense)) * 100).toStringAsFixed(1)}%',
                      color: Colors.red,
                      radius: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCategoryBreakdown(AdvancedReportData data, BuildContext context, String locale) {
    if (data.categoryBreakdown.isEmpty) {
      return const SizedBox();
    }
    
    final sortedCategories = data.categoryBreakdown.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('expense_by_category'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...sortedCategories.take(5).map((entry) {
              final categoryName = entry.key;
              final amount = entry.value;
              final percentage = data.totalExpense > 0 
                  ? (amount / data.totalExpense) * 100 
                  : 0.0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.tr('category.$categoryName'),
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          NumberUtils.formatCurrency(amount, locale: locale),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor: Colors.grey.shade200,
                      minHeight: 8,
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDailyTrendChart(AdvancedReportData data, BuildContext context) {
    if (data.dailyTrend.isEmpty) {
      return const SizedBox();
    }
    
    final sortedDays = data.dailyTrend.keys.toList()..sort();
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('daily_trend'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: sortedDays.asMap().entries.map((entry) {
                        return FlSpot(
                          entry.key.toDouble(),
                          data.dailyTrend[entry.value]!.toDouble(),
                        );
                      }).toList(),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAccountBreakdown(AdvancedReportData data, BuildContext context, String locale) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('by_account'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...data.accountBreakdown.entries.map((entry) {
              return ListTile(
                leading: const Icon(Icons.account_balance_wallet),
                title: Text(entry.key),
                trailing: Text(
                  NumberUtils.formatCurrency(entry.value, locale: locale),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTransactionsList(AdvancedReportData data, BuildContext context, String locale) {
    if (data.transactions.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Center(
            child: Text(
              context.tr('no_transactions_in_period'),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('transactions'),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${data.transactions.length} ${context.tr('items')}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...data.transactions.take(10).map((transaction) {
              return ListTile(
                leading: Icon(
                  transaction.category.icon,
                  color: transaction.category.color,
                ),
                title: Text(transaction.note ?? context.tr('category.${transaction.category.name}')),
                subtitle: Text(DateFormat('yyyy/MM/dd').format(transaction.dateTime)),
                trailing: Text(
                  '${transaction.isIncome ? '+' : '-'}${NumberUtils.formatCurrency(transaction.amount, locale: locale)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: transaction.isIncome ? Colors.green : Colors.red,
                  ),
                ),
              );
            }),
            if (data.transactions.length > 10)
              Center(
                child: TextButton(
                  onPressed: () {
                    // Show all transactions
                  },
                  child: Text(context.tr('see_all_transactions')),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Future<AdvancedReportData> _generateReport() async {
    final getRecentTransactions = ref.read(getRecentTransactionsProvider);
    final transactionsResult = await getRecentTransactions(const GetRecentTransactionsParams(limit: 1000));
    
    return transactionsResult.fold(
      (failure) => const AdvancedReportData(
        totalIncome: 0,
        totalExpense: 0,
        netAmount: 0,
        transactionCount: 0,
        categoryBreakdown: {},
        accountBreakdown: {},
        labelBreakdown: {},
        dailyTrend: {},
        transactions: [],
      ),
      (allTransactions) {
        // Filter transactions by date range and selected filters
        final filteredTransactions = allTransactions.where((t) {
          final isInDateRange = t.dateTime.isAfter(_startDate.subtract(const Duration(days: 1))) &&
              t.dateTime.isBefore(_endDate.add(const Duration(days: 1)));
          
          final matchesType = _selectedTypes.contains(t.type);
          
          final matchesCategory = _selectedCategories.isEmpty ||
              _selectedCategories.contains(t.category);
          
          return isInDateRange && matchesType && matchesCategory;
        }).toList();
        
        // Calculate statistics
        int totalIncome = 0;
        int totalExpense = 0;
        final Map<String, int> categoryBreakdown = {};
        final Map<String, int> accountBreakdown = {};
        final Map<String, int> dailyTrend = {};
        
        for (var transaction in filteredTransactions) {
          final int transactionAmount = transaction.amount;
          
          if (transaction.isIncome) {
            totalIncome += transactionAmount;
          } else {
            totalExpense += transactionAmount;
            
            // Category breakdown (only for expenses)
            final categoryName = transaction.category.name;
            categoryBreakdown[categoryName] = (categoryBreakdown[categoryName] ?? 0) + transactionAmount;
          }
          
          // Account breakdown
          accountBreakdown[transaction.accountId] = (accountBreakdown[transaction.accountId] ?? 0) + transactionAmount;
          
          // Daily trend
          final dayKey = DateFormat('yyyy-MM-dd').format(transaction.dateTime);
          dailyTrend[dayKey] = (dailyTrend[dayKey] ?? 0) + transactionAmount;
        }
        
        return AdvancedReportData(
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          netAmount: totalIncome - totalExpense,
          transactionCount: filteredTransactions.length,
          categoryBreakdown: categoryBreakdown,
          accountBreakdown: accountBreakdown,
          labelBreakdown: {},
          dailyTrend: dailyTrend,
          transactions: filteredTransactions,
        );
      },
    );
  }
  
  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }
  
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('filter')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              title: Text(context.tr('income')),
              value: _selectedTypes.contains(TransactionType.income),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedTypes.add(TransactionType.income);
                  } else {
                    _selectedTypes.remove(TransactionType.income);
                  }
                });
              },
            ),
            CheckboxListTile(
              title: Text(context.tr('expense')),
              value: _selectedTypes.contains(TransactionType.expense),
              onChanged: (value) {
                setState(() {
                  if (value == true) {
                    _selectedTypes.add(TransactionType.expense);
                  } else {
                    _selectedTypes.remove(TransactionType.expense);
                  }
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {});
              Navigator.pop(context);
            },
            child: Text(context.tr('apply')),
          ),
        ],
      ),
    );
  }
  
  void _exportReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('export_feature_coming_soon')),
      ),
    );
  }
}
