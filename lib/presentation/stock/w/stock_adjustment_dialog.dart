import 'package:clean_arch_app/di/injection.dart';
import 'package:clean_arch_app/domain/entities/stock/stock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../stock_view_model.dart';class StockAdjustmentDialog extends StatefulWidget {
  final Stock stock;
  final bool isEditMode;

  const StockAdjustmentDialog({
    super.key,
    required this.stock,
    this.isEditMode = false,
  });

  @override
  State<StockAdjustmentDialog> createState() => _StockAdjustmentDialogState();
}

class _StockAdjustmentDialogState extends State<StockAdjustmentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _adjustmentController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _reorderPointController = TextEditingController();

  bool _isLoading = false;
  AdjustmentType _adjustmentType = AdjustmentType.add;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {_nameController.text = widget.stock.name;
      _descriptionController.text = widget.stock.description ?? '';
      _priceController.text = (widget.stock.price ?? 0.0).toString();
      _reorderPointController.text = (widget.stock.minimumStock ?? 0).toString();
    }
  }

  @override
  void dispose() {
    _adjustmentController.dispose();
    _reasonController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _reorderPointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, WidgetRef ref, child) {
        final viewModel = ref.watch(stockViewModelProvider.notifier);

        if (!viewModel.canAdjustStock && !widget.isEditMode) {return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text(
                'You do not have permission to adjust stock quantities.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        }

        if (widget.isEditMode && !viewModel.canEditStock) {
          return AlertDialog(
            title: const Text('Permission Denied'),
            content: const Text('You do not have permission to edit stock items.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        }

        return _buildDialog(context, ref);
      },
    );
  }

  Widget _buildDialog(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildHeader(), _buildContent(), _buildActions(ref)],
          ),
        ),
      ),
    );
  }Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [Icon(
            widget.isEditMode ? Icons.edit : Icons.inventory_2,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(
                  widget.isEditMode
                      ? 'Edit Stock Item'
                      : 'Adjust Stock: ${widget.stock.name}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!widget.isEditMode)
                  Text(
                    'Current Quantity: ${widget.stock.quantity} ${widget.stock.unit ?? "pcs"}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: widget.isEditMode ? _buildEditForm() : _buildAdjustmentForm(),
    );
  }

  Widget _buildEditForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [TextFormField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Product Name',
            prefixIcon: Icon(Icons.label),
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a product name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'Description (Optional)',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  prefixIcon: Icon(Icons.attach_money),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _reorderPointController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reorder Point',
                  prefixIcon: Icon(Icons.low_priority),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter reorder point';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdjustmentForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [Expanded(
              child: RadioListTile<AdjustmentType>(
                title: const Text('Add'),
                value: AdjustmentType.add,
                groupValue: _adjustmentType,
                onChanged: (value) {
                  setState(() {
                    _adjustmentType = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<AdjustmentType>(
                title: const Text('Remove'),
                value: AdjustmentType.remove,
                groupValue: _adjustmentType,
                onChanged: (value) {
                  setState(() {
                    _adjustmentType = value!;
                  });
                },
              ),
            ),
          ],
        ),const SizedBox(height: 16),
        TextFormField(
          controller: _adjustmentController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Quantity',
            prefixIcon: Icon(
              _adjustmentType == AdjustmentType.add
                  ? Icons.add_circle
                  : Icons.remove_circle,
            ),
            suffixText: widget.stock.unit ?? "pcs",
            border: const OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter adjustment quantity';
            }
            final adjustment = int.tryParse(value);
            if (adjustment == null || adjustment <= 0) {
              return 'Please enter a valid positive number';
            }
            if (_adjustmentType == AdjustmentType.remove &&
                adjustment > widget.stock.quantity) {
              return 'Cannot remove more than current quantity';
            }
            return null;
          },
        ),const SizedBox(height: 16),
        TextFormField(
          controller: _reasonController,
          decoration: const InputDecoration(
            labelText: 'Reason for Adjustment',
            prefixIcon: Icon(Icons.comment),
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please provide a reason for the adjustment';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),child: Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _getNewQuantityText(),
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }Widget _buildActions(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : () => _submit(ref),child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(widget.isEditMode ? 'Update' : 'Confirm Adjustment'),
          ),
        ],
      ),
    );
  }

  String _getNewQuantityText() {
    final adjustmentText = _adjustmentController.text;
    if (adjustmentText.isEmpty) {
      return 'Enter a quantity to see the new total';
    }

    final adjustment = int.tryParse(adjustmentText) ?? 0;
    if (adjustment == 0) {
      return 'Enter a valid quantity';
    }

    final newQuantity = _adjustmentType == AdjustmentType.add
        ? widget.stock.quantity + adjustment
        : widget.stock.quantity - adjustment;

    return 'New quantity will be: $newQuantity ${widget.stock.unit ?? "pcs"}';
  }

  void _submit(WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final viewModel = ref.read(stockViewModelProvider.notifier);

    try {
      if (widget.isEditMode) {
        final updatedStock = widget.stock.copyWith(
          name: _nameController.text,
          description: _descriptionController.text.isEmpty
              ? null
              : _descriptionController.text,
          price: double.parse(_priceController.text),
        );
        await viewModel.updateStock(updatedStock);
      } else {
        final adjustment = int.parse(_adjustmentController.text);
        final finalAdjustment = _adjustmentType == AdjustmentType.add
            ? adjustment
            : -adjustment;
        await viewModel.adjustStock(
          widget.stock.id,
          finalAdjustment,
          _reasonController.text.trim(),
        );
      }

      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

enum AdjustmentType { add, remove }
