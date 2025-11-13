import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/core/theme/app_theme.dart';
import 'package:financial_management/core/utils/date_time_utils.dart';
import 'package:financial_management/domain/entities/account.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/presentation/screens/account_form_screen.dart';
import 'package:financial_management/presentation/screens/accounts_list_screen.dart';
import 'package:financial_management/presentation/screens/labels_list_screen.dart';
import 'package:financial_management/presentation/screens/reports_screen.dart';
import 'package:financial_management/presentation/screens/transaction_form_screen.dart';
import 'package:financial_management/presentation/screens/transactions_list_screen.dart';
import 'package:financial_management/presentation/viewmodels/dashboard_viewmodel.dart';
import 'package:financial_management/presentation/widgets/account_card.dart';
import 'package:financial_management/presentation/widgets/balance_card.dart';
import 'package:financial_management/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});
  
  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when screen initializes
    Future.microtask(() {
      ref.read(dashboardViewModelProvider.notifier).loadDashboardData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardViewModelProvider);
    final locale = Localizations.localeOf(context).languageCode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('dashboard')),
        actions: [
          IconButton(
            icon: const Icon(Icons.assessment),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportsScreen(),
                ),
              );
            },
            tooltip: context.tr('reports'),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'labels':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LabelsListScreen(),
                    ),
                  );
                  break;
                case 'refresh':
                  ref.read(dashboardViewModelProvider.notifier).refresh();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'labels',
                child: Row(
                  children: [
                    const Icon(Icons.label_outline),
                    const SizedBox(width: 12),
                    Text(context.tr('labels')),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'refresh',
                child: Row(
                  children: [
                    const Icon(Icons.refresh),
                    const SizedBox(width: 12),
                    Text(context.tr('refresh')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: state.isLoading && state.accounts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                ref.read(dashboardViewModelProvider.notifier).refresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total Balance Card
                      BalanceCard(
                        balance: state.totalBalance,
                        locale: locale,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Accounts Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('accounts'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AccountFormScreen(),
                                ),
                              );
                              if (result == true && mounted) {
                                ref.read(dashboardViewModelProvider.notifier).refresh();
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: Text(context.tr('add_account')),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      if (state.accounts.isEmpty)
                        _EmptyAccountsWidget()
                      else
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.accounts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: AccountCard(
                                  account: state.accounts[index],
                                  locale: locale,
                                ),
                              );
                            },
                          ),
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // Recent Transactions Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            context.tr('recent_transactions'),
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TransactionsListScreen(),
                                ),
                              );
                              if (mounted) {
                                ref.read(dashboardViewModelProvider.notifier).refresh();
                              }
                            },
                            child: Text(context.tr('see_all')),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      if (state.recentTransactions.isEmpty)
                        _EmptyTransactionsWidget()
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.recentTransactions.length,
                          itemBuilder: (context, index) {
                            return TransactionListItem(
                              transaction: state.recentTransactions[index],
                              locale: locale,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionFormScreen(),
            ),
          );
          if (result == true && mounted) {
            ref.read(dashboardViewModelProvider.notifier).refresh();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(context.tr('add_transaction')),
      ),
    );
  }
}

class _EmptyAccountsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('no_accounts'),
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyTransactionsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              context.tr('no_transactions'),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
