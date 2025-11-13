import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/domain/entities/transaction_label.dart';
import 'package:financial_management/presentation/screens/label_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LabelsListScreen extends ConsumerStatefulWidget {
  const LabelsListScreen({super.key});
  
  @override
  ConsumerState<LabelsListScreen> createState() => _LabelsListScreenState();
}

class _LabelsListScreenState extends ConsumerState<LabelsListScreen> {
  // TODO: Replace with actual data from repository
  final List<TransactionLabel> _sampleLabels = [
    TransactionLabel(
      id: '1',
      name: 'Coffee',
      color: TransactionLabel.colorToString(Colors.brown),
      icon: TransactionLabel.iconToString(Icons.coffee),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    TransactionLabel(
      id: '2',
      name: 'Travel',
      color: TransactionLabel.colorToString(Colors.blue),
      icon: TransactionLabel.iconToString(Icons.flight),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    TransactionLabel(
      id: '3',
      name: 'Gym',
      color: TransactionLabel.colorToString(Colors.orange),
      icon: TransactionLabel.iconToString(Icons.fitness_center),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('labels')),
      ),
      body: _sampleLabels.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _sampleLabels.length,
              itemBuilder: (context, index) {
                final label = _sampleLabels[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: label.getColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        label.getIcon(),
                        color: label.getColor(),
                      ),
                    ),
                    title: Text(
                      label.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${context.tr('created')}: ${_formatDate(label.createdAt)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _editLabel(label),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createLabel,
        icon: const Icon(Icons.add),
        label: Text(context.tr('add_label')),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.label_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            context.tr('no_labels'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            context.tr('create_first_label'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _createLabel,
            icon: const Icon(Icons.add),
            label: Text(context.tr('add_label')),
          ),
        ],
      ),
    );
  }
  
  Future<void> _createLabel() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LabelFormScreen(),
      ),
    );
    
    if (result == true && mounted) {
      setState(() {
        // TODO: Refresh labels from repository
      });
    }
  }
  
  Future<void> _editLabel(TransactionLabel label) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LabelFormScreen(label: label),
      ),
    );
    
    if (result == true && mounted) {
      setState(() {
        // TODO: Refresh labels from repository
      });
    }
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return context.tr('today');
    } else if (difference == 1) {
      return context.tr('yesterday');
    } else if (difference < 7) {
      return '${difference} ${context.tr('days_ago')}';
    } else {
      return '${date.year}/${date.month}/${date.day}';
    }
  }
}
