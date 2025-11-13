import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/core/usecases/usecase.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:financial_management/domain/usecases/account/get_all_accounts.dart';
import 'package:financial_management/domain/usecases/transaction/create_transaction.dart';
import 'package:financial_management/presentation/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class TransactionFormScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;
  
  const TransactionFormScreen({
    super.key,
    this.transaction,
  });
  
  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  
  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory _selectedCategory = TransactionCategory.food;
  String? _selectedAccountId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      _amountController.text = widget.transaction!.amount.toString();
      _noteController.text = widget.transaction!.note ?? '';
      _selectedType = widget.transaction!.type;
      _selectedCategory = widget.transaction!.category;
      _selectedAccountId = widget.transaction!.accountId;
      _selectedDate = widget.transaction!.dateTime;
    }
    
    // Load accounts
    Future.microtask(() {
      ref.read(getAllAccountsUseCaseProvider)();
    });
  }
  
  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }
  
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }
  
  Future<void> _saveTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('please_select_account')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final createTransaction = ref.read(createTransactionProvider);
      
      final result = await createTransaction(CreateTransactionParams(
        amount: int.parse(_amountController.text.trim()),
        type: _selectedType,
        accountId: _selectedAccountId!,
        dateTime: _selectedDate,
        category: _selectedCategory,
        note: _noteController.text.trim().isEmpty 
            ? null 
            : _noteController.text.trim(),
        imagePath: widget.transaction?.imagePath,
        smsId: widget.transaction?.smsId,
      ));
      
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('error_saving_transaction')),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('transaction_saved_successfully')),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.tr('error_saving_transaction')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? context.tr('edit_transaction') : context.tr('add_transaction')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Transaction Type Selector
            SegmentedButton<TransactionType>(
              selected: {_selectedType},
              onSelectionChanged: (Set<TransactionType> selection) {
                setState(() => _selectedType = selection.first);
              },
              segments: [
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text(context.tr('income')),
                  icon: const Icon(Icons.arrow_downward, color: Colors.green),
                ),
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text(context.tr('expense')),
                  icon: const Icon(Icons.arrow_upward, color: Colors.red),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Amount
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: context.tr('amount'),
                hintText: '0',
                prefixIcon: const Icon(Icons.monetization_on),
                border: const OutlineInputBorder(),
                suffix: Text(context.tr('currency')),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr('please_enter_amount');
                }
                final amount = int.tryParse(value.trim());
                if (amount == null || amount <= 0) {
                  return context.tr('invalid_amount');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Account Selection
            FutureBuilder(
              future: ref.read(getAllAccountsProvider)(NoParams()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator();
                }
                
                if (snapshot.hasError) {
                  return Text(
                    context.tr('error_loading_accounts'),
                    style: const TextStyle(color: Colors.red),
                  );
                }
                
                return snapshot.data?.fold(
                  (failure) => Text(
                    context.tr('error_loading_accounts'),
                    style: const TextStyle(color: Colors.red),
                  ),
                  (accounts) {
                    if (accounts.isEmpty) {
                      return Card(
                        color: Colors.orange.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                context.tr('no_accounts_available'),
                                style: TextStyle(color: Colors.orange.shade900),
                              ),
                              const SizedBox(height: 8),
                              TextButton.icon(
                                onPressed: () {
                                  // Navigate to add account
                                  Navigator.pushNamed(context, '/account/add');
                                },
                                icon: const Icon(Icons.add),
                                label: Text(context.tr('add_account')),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    
                    if (_selectedAccountId == null && accounts.isNotEmpty) {
                      _selectedAccountId = accounts.first.id;
                    }
                    
                    return DropdownButtonFormField<String>(
                      value: _selectedAccountId,
                      decoration: InputDecoration(
                        labelText: context.tr('account'),
                        prefixIcon: const Icon(Icons.account_balance_wallet),
                        border: const OutlineInputBorder(),
                      ),
                      items: accounts.map((account) {
                        return DropdownMenuItem(
                          value: account.id,
                          child: Text(account.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedAccountId = value);
                      },
                      validator: (value) {
                        if (value == null) {
                          return context.tr('please_select_account');
                        }
                        return null;
                      },
                    );
                  },
                ) ?? const SizedBox();
              },
            ),
            
            const SizedBox(height: 16),
            
            // Category Selection
            DropdownButtonFormField<TransactionCategory>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: context.tr('category'),
                prefixIcon: Icon(_selectedCategory.icon),
                border: const OutlineInputBorder(),
              ),
              items: TransactionCategory.values.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Row(
                    children: [
                      Icon(category.icon, size: 20, color: category.color),
                      const SizedBox(width: 8),
                      Text(context.tr(category.nameKey)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCategory = value);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Date Selection
            InkWell(
              onTap: _selectDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: context.tr('date'),
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: const OutlineInputBorder(),
                ),
                child: Text(
                  '${_selectedDate.year}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.day.toString().padLeft(2, '0')}',
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Note
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: context.tr('note_optional'),
                hintText: context.tr('enter_note'),
                prefixIcon: const Icon(Icons.note),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveTransaction,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      isEditing ? context.tr('save_changes') : context.tr('create_transaction'),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
