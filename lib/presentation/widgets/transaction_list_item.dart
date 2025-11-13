import 'package:financial_management/core/utils/date_time_utils.dart';
import 'package:financial_management/domain/entities/transaction.dart';
import 'package:flutter/material.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final String locale;
  
  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.locale,
  });
  
  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: transaction.category.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            transaction.category.icon,
            color: transaction.category.color,
            size: 24,
          ),
        ),
        title: Text(
          transaction.note ?? transaction.category.name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          DateTimeUtils.toJalaliWithTime(transaction.dateTime),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 13,
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isIncome ? '+' : '-'} ${NumberUtils.formatCurrency(transaction.amount, locale: locale)}',
              style: TextStyle(
                color: isIncome ? Colors.green[600] : Colors.red[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              locale == 'fa' ? 'ریال' : 'Rial',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
