import 'package:equatable/equatable.dart';
import 'package:financial_management/core/constants/category_constants.dart';

/// Account entity representing a financial account
class Account extends Equatable {
  final String id;
  final String name;
  final AccountType type;
  final int balance;
  final String? description;
  final String? color;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.description,
    this.color,
    required this.createdAt,
    required this.updatedAt,
  });
  
  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    int? balance,
    String? description,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      balance: balance ?? this.balance,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    name,
    type,
    balance,
    description,
    color,
    createdAt,
    updatedAt,
  ];
}
