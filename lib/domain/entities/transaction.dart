import 'package:equatable/equatable.dart';
import 'package:financial_management/core/constants/category_constants.dart';

/// Transaction type enum
enum TransactionType { income, expense }

/// Transaction entity representing a financial transaction
class Transaction extends Equatable {
  final String id;
  final int amount;
  final TransactionType type;
  final String accountId;
  final DateTime dateTime;
  final TransactionCategory category;
  final String? note;
  final String? imagePath;
  final String? smsId;
  final List<String>? labelIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.accountId,
    required this.dateTime,
    required this.category,
    this.note,
    this.imagePath,
    this.smsId,
    this.labelIds,
    required this.createdAt,
    required this.updatedAt,
  });
  
  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
  
  Transaction copyWith({
    String? id,
    int? amount,
    TransactionType? type,
    String? accountId,
    DateTime? dateTime,
    TransactionCategory? category,
    String? note,
    String? imagePath,
    String? smsId,
    List<String>? labelIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      accountId: accountId ?? this.accountId,
      dateTime: dateTime ?? this.dateTime,
      category: category ?? this.category,
      note: note ?? this.note,
      imagePath: imagePath ?? this.imagePath,
      smsId: smsId ?? this.smsId,
      labelIds: labelIds ?? this.labelIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    amount,
    type,
    accountId,
    dateTime,
    category,
    note,
    imagePath,
    smsId,
    labelIds,
    createdAt,
    updatedAt,
  ];
}
