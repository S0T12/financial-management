import 'package:equatable/equatable.dart';

/// Transfer entity representing money transfer between accounts
class Transfer extends Equatable {
  final String id;
  final String fromAccountId;
  final String toAccountId;
  final int amount;
  final String? note;
  final DateTime dateTime;
  final DateTime createdAt;
  
  const Transfer({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    this.note,
    required this.dateTime,
    required this.createdAt,
  });
  
  Transfer copyWith({
    String? id,
    String? fromAccountId,
    String? toAccountId,
    int? amount,
    String? note,
    DateTime? dateTime,
    DateTime? createdAt,
  }) {
    return Transfer(
      id: id ?? this.id,
      fromAccountId: fromAccountId ?? this.fromAccountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      dateTime: dateTime ?? this.dateTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
  
  @override
  List<Object?> get props => [
    id,
    fromAccountId,
    toAccountId,
    amount,
    note,
    dateTime,
    createdAt,
  ];
}
