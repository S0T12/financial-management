import 'package:equatable/equatable.dart';

/// Label/Tag entity for categorizing transactions
class TransactionLabel extends Equatable {
  final String id;
  final String name;
  final String? color;
  final String? icon;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  const TransactionLabel({
    required this.id,
    required this.name,
    this.color,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });
  
  TransactionLabel copyWith({
    String? id,
    String? name,
    String? color,
    String? icon,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionLabel(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
  
  @override
  List<Object?> get props => [id, name, color, icon, createdAt, updatedAt];
}
