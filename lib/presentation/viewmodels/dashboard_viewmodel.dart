import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/account.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/presentation/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Dashboard state
class DashboardState {
  final List<Account> accounts;
  final List<Transaction> recentTransactions;
  final int totalBalance;
  final bool isLoading;
  final String? errorMessage;
  
  const DashboardState({
    this.accounts = const [],
    this.recentTransactions = const [],
    this.totalBalance = 0,
    this.isLoading = false,
    this.errorMessage,
  });
  
  DashboardState copyWith({
    List<Account>? accounts,
    List<Transaction>? recentTransactions,
    int? totalBalance,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DashboardState(
      accounts: accounts ?? this.accounts,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      totalBalance: totalBalance ?? this.totalBalance,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

/// Dashboard ViewModel
class DashboardViewModel extends StateNotifier<DashboardState> {
  final GetAllAccounts getAllAccounts;
  final GetRecentTransactions getRecentTransactions;
  
  DashboardViewModel({
    required this.getAllAccounts,
    required this.getRecentTransactions,
  }) : super(const DashboardState());
  
  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    // Load accounts
    final accountsResult = await getAllAccounts(const NoParams());
    
    accountsResult.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (accounts) async {
        final totalBalance = accounts.fold<int>(
          0,
          (sum, account) => sum + account.balance,
        );
        
        // Load recent transactions
        final transactionsResult = await getRecentTransactions(
          const GetRecentTransactionsParams(limit: 10),
        );
        
        transactionsResult.fold(
          (failure) {
            state = state.copyWith(
              accounts: accounts,
              totalBalance: totalBalance,
              isLoading: false,
              errorMessage: failure.message,
            );
          },
          (transactions) {
            state = state.copyWith(
              accounts: accounts,
              recentTransactions: transactions,
              totalBalance: totalBalance,
              isLoading: false,
            );
          },
        );
      },
    );
  }
  
  void refresh() {
    loadDashboardData();
  }
}

/// Dashboard ViewModel Provider
final dashboardViewModelProvider = StateNotifierProvider<DashboardViewModel, DashboardState>((ref) {
  return DashboardViewModel(
    getAllAccounts: ref.watch(getAllAccountsProvider),
    getRecentTransactions: ref.watch(getRecentTransactionsProvider),
  );
});
