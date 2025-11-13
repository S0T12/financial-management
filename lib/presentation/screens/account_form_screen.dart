import 'package:financial_management/core/constants/category_constants.dart';
import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/domain/entities/account.dart';
import 'package:financial_management/domain/usecases/account/create_account.dart';
import 'package:financial_management/presentation/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  final Account? account;
  
  const AccountFormScreen({
    super.key,
    this.account,
  });
  
  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  AccountType _selectedType = AccountType.personal;
  String? _selectedColor;
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    if (widget.account != null) {
      _nameController.text = widget.account!.name;
      _balanceController.text = widget.account!.balance.toString();
      _descriptionController.text = widget.account!.description ?? '';
      _selectedType = widget.account!.type;
      _selectedColor = widget.account!.color;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
  
  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final createAccount = ref.read(createAccountUseCaseProvider);
      
      final account = Account(
        id: widget.account?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        type: _selectedType,
        balance: int.parse(_balanceController.text.trim()),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
        color: _selectedColor,
        createdAt: widget.account?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      final result = await createAccount(CreateAccountParams(account: account));
      
      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('error_saving_account')),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        (_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.tr('account_saved_successfully')),
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
            content: Text(context.tr('error_saving_account')),
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
    final isEditing = widget.account != null;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? context.tr('edit_account') : context.tr('add_account')),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Account Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: context.tr('account_name'),
                hintText: context.tr('enter_account_name'),
                prefixIcon: const Icon(Icons.account_balance_wallet),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr('please_enter_account_name');
                }
                if (value.trim().length < 2) {
                  return context.tr('account_name_too_short');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Account Type
            DropdownButtonFormField<AccountType>(
              value: _selectedType,
              decoration: InputDecoration(
                labelText: context.tr('account_type'),
                prefixIcon: Icon(_selectedType.icon),
                border: const OutlineInputBorder(),
              ),
              items: AccountType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Row(
                    children: [
                      Icon(type.icon, size: 20),
                      const SizedBox(width: 8),
                      Text(context.tr(type.nameKey)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedType = value);
                }
              },
            ),
            
            const SizedBox(height: 16),
            
            // Initial Balance
            TextFormField(
              controller: _balanceController,
              decoration: InputDecoration(
                labelText: isEditing ? context.tr('current_balance') : context.tr('initial_balance'),
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
                  return context.tr('please_enter_balance');
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: context.tr('description_optional'),
                hintText: context.tr('enter_description'),
                prefixIcon: const Icon(Icons.description),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            
            const SizedBox(height: 24),
            
            // Color Selector
            Text(
              context.tr('select_color'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: _getColorOptions().map((colorHex) {
                final color = Color(int.parse(colorHex.substring(1), radix: 16) + 0xFF000000);
                final isSelected = _selectedColor == colorHex;
                
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = colorHex);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveAccount,
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
                      isEditing ? context.tr('save_changes') : context.tr('create_account'),
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
  
  List<String> _getColorOptions() {
    return [
      '#3B82F6', // Blue
      '#8B5CF6', // Purple
      '#EC4899', // Pink
      '#10B981', // Green
      '#F59E0B', // Amber
      '#EF4444', // Red
      '#06B6D4', // Cyan
      '#F97316', // Orange
      '#14B8A6', // Teal
      '#A855F7', // Violet
    ];
  }
}
