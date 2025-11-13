import 'package:flutter/material.dart';

/// Transaction category definitions
enum TransactionCategory {
  food,
  transport,
  shopping,
  entertainment,
  health,
  education,
  bills,
  salary,
  business,
  investment,
  gift,
  other;
  
  String get nameKey => 'category.$name';
  
  IconData get icon {
    switch (this) {
      case TransactionCategory.food:
        return Icons.restaurant;
      case TransactionCategory.transport:
        return Icons.directions_car;
      case TransactionCategory.shopping:
        return Icons.shopping_bag;
      case TransactionCategory.entertainment:
        return Icons.movie;
      case TransactionCategory.health:
        return Icons.local_hospital;
      case TransactionCategory.education:
        return Icons.school;
      case TransactionCategory.bills:
        return Icons.receipt_long;
      case TransactionCategory.salary:
        return Icons.attach_money;
      case TransactionCategory.business:
        return Icons.business_center;
      case TransactionCategory.investment:
        return Icons.trending_up;
      case TransactionCategory.gift:
        return Icons.card_giftcard;
      case TransactionCategory.other:
        return Icons.more_horiz;
    }
  }
  
  Color get color {
    switch (this) {
      case TransactionCategory.food:
        return const Color(0xFFFF6B6B);
      case TransactionCategory.transport:
        return const Color(0xFF4ECDC4);
      case TransactionCategory.shopping:
        return const Color(0xFFFFBE0B);
      case TransactionCategory.entertainment:
        return const Color(0xFFFF006E);
      case TransactionCategory.health:
        return const Color(0xFF06FFA5);
      case TransactionCategory.education:
        return const Color(0xFF8338EC);
      case TransactionCategory.bills:
        return const Color(0xFFFF9F1C);
      case TransactionCategory.salary:
        return const Color(0xFF06D6A0);
      case TransactionCategory.business:
        return const Color(0xFF118AB2);
      case TransactionCategory.investment:
        return const Color(0xFF073B4C);
      case TransactionCategory.gift:
        return const Color(0xFFE63946);
      case TransactionCategory.other:
        return const Color(0xFF6C757D);
    }
  }
}

/// Account type definitions
enum AccountType {
  personal,
  business,
  family,
  savings;
  
  String get nameKey => 'account_type.$name';
  
  IconData get icon {
    switch (this) {
      case AccountType.personal:
        return Icons.person;
      case AccountType.business:
        return Icons.business;
      case AccountType.family:
        return Icons.family_restroom;
      case AccountType.savings:
        return Icons.savings;
    }
  }
  
  Color get color {
    switch (this) {
      case AccountType.personal:
        return const Color(0xFF3B82F6);
      case AccountType.business:
        return const Color(0xFF8B5CF6);
      case AccountType.family:
        return const Color(0xFFEC4899);
      case AccountType.savings:
        return const Color(0xFF10B981);
    }
  }
}
