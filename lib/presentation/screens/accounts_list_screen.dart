import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/usecases/account/get_all_accounts.dart';
import 'package:financial_management/presentation/providers/app_providers.dart';
import 'package:financial_management/presentation/screens/account_form_screen.dart';
import 'package:financial_management/presentation/widgets/account_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsListScreen extends ConsumerStatefulWidget {
  const AccountsListScreen({super.key});
  
  @override
  ConsumerState<AccountsListScreen> createState() => _AccountsListScreenState();
}

class _AccountsListScreenState extends ConsumerState<AccountsListScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('accounts')),
      ),
      body: FutureBuilder(
        future: ref.read(getAllAccountsProvider)(NoParams()),
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
                    context.tr('error_loading_accounts'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          
          return snapshot.data?.fold(
            (failure) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    context.tr('error_loading_accounts'),
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            (accounts) {
              if (accounts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        context.tr('no_accounts'),
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AccountFormScreen(),
                            ),
                          );
                          if (result == true && mounted) {
                            setState(() {});
                          }
                        },
                        icon: const Icon(Icons.add),
                        label: Text(context.tr('add_first_account')),
                      ),
                    ],
                  ),
                );
              }
              
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AccountCard(
                      account: account,
                      locale: locale,
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountFormScreen(account: account),
                          ),
                        );
                        if (result == true && mounted) {
                          setState(() {});
                        }
                      },
                    ),
                  );
                },
              );
            },
          ) ?? const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountFormScreen(),
            ),
          );
          if (result == true && mounted) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
