import 'package:financial_management/core/localization/app_localizations.dart';
import 'package:financial_management/domain/entities/transaction_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LabelFormScreen extends ConsumerStatefulWidget {
  final TransactionLabel? label;
  
  const LabelFormScreen({super.key, this.label});
  
  @override
  ConsumerState<LabelFormScreen> createState() => _LabelFormScreenState();
}

class _LabelFormScreenState extends ConsumerState<LabelFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  Color _selectedColor = Colors.blue;
  IconData _selectedIcon = Icons.label;
  
  final List<Color> _availableColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];
  
  final List<IconData> _availableIcons = [
    Icons.label,
    Icons.coffee,
    Icons.restaurant,
    Icons.shopping_bag,
    Icons.home,
    Icons.directions_car,
    Icons.flight,
    Icons.local_hospital,
    Icons.school,
    Icons.sports_soccer,
    Icons.movie,
    Icons.music_note,
    Icons.favorite,
    Icons.star,
    Icons.work,
    Icons.pets,
  ];
  
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _isEditing = widget.label != null;
    _nameController = TextEditingController(text: widget.label?.name ?? '');
    if (widget.label != null) {
      _selectedColor = widget.label!.color;
      _selectedIcon = widget.label!.icon;
    }
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? context.tr('edit_label') : context.tr('create_label')),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Label Preview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _selectedIcon,
                          color: _selectedColor,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _nameController.text.isEmpty 
                              ? context.tr('label_preview') 
                              : _nameController.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.tr('label_name'),
                  hintText: context.tr('enter_label_name'),
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.label_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return context.tr('please_enter_label_name');
                  }
                  if (value.trim().length < 2) {
                    return context.tr('label_name_too_short');
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              
              const SizedBox(height: 24),
              
              // Color Picker
              Text(
                context.tr('select_color'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableColors.map((color) {
                  final isSelected = color == _selectedColor;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = color),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 3,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withOpacity(0.5),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Icon Picker
              Text(
                context.tr('select_icon'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableIcons.map((icon) {
                  final isSelected = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? _selectedColor.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? _selectedColor : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: isSelected ? _selectedColor : Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 32),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveLabel,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _isEditing ? context.tr('save_changes') : context.tr('create_label'),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _saveLabel() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    // TODO: Implement save logic with repository
    final label = TransactionLabel(
      id: widget.label?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      color: _selectedColor,
      icon: _selectedIcon,
      createdAt: widget.label?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    Navigator.pop(context, true);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing 
              ? context.tr('label_updated_successfully')
              : context.tr('label_created_successfully'),
        ),
      ),
    );
  }
  
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('confirm_delete')),
        content: Text(context.tr('confirm_delete_label')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement delete logic
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Close screen
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('label_deleted_successfully')),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text(context.tr('delete')),
          ),
        ],
      ),
    );
  }
}
