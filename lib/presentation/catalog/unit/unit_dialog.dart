import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/general/unit.dart';

class UnitDialog extends ConsumerStatefulWidget {
  final Unit? unit;
  final Function(Unit) onSubmit;

  const UnitDialog({
    super.key,
    this.unit,
    required this.onSubmit,
  });

  @override
  ConsumerState<UnitDialog> createState() => _UnitDialogState();
}

class _UnitDialogState extends ConsumerState<UnitDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _conversionRateController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.unit?.name ?? '');
    _descriptionController = TextEditingController(text: widget.unit?.description ?? '');
    _conversionRateController = TextEditingController(
      text: widget.unit?.conversionRate?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _conversionRateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.unit != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Unit' : 'Add Unit'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Unit Name (e.g., kg, pcs, litre)',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _conversionRateController,
              decoration: const InputDecoration(
                labelText: 'Conversion Rate (Optional)',
                hintText: 'e.g., 1000 for kg to grams',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Please enter a valid positive number';
                  }
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0E2330),
            foregroundColor: Colors.white,
          ),
          child: Text(isEditing ? 'Update' : 'Create'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final conversionRate = _conversionRateController.text.trim().isEmpty
        ? null
        : double.tryParse(_conversionRateController.text.trim());

      final unit = Unit(
        id: widget.unit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
        conversionRate: conversionRate,
      );

      widget.onSubmit(unit);
      Navigator.of(context).pop();
    }
  }
}