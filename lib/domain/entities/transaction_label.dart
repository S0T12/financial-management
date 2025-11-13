import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
  
  // Helper methods to convert to/from Flutter types
  Color getColor() {
    if (color == null) return Colors.blue;
    try {
      return Color(int.parse(color!.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.blue;
    }
  }
  
  IconData getIcon() {
    if (icon == null) return Icons.label;
    try {
      final codePoint = int.parse(icon!);
      return IconData(codePoint, fontFamily: 'MaterialIcons');
    } catch (e) {
      return Icons.label;
    }
  }
  
  static String colorToString(Color color) {
    return '#${color.value.toRadixString(16).substring(2)}';
  }
  
  static String iconToString(IconData icon) {
    return icon.codePoint.toString();
  }
  
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
