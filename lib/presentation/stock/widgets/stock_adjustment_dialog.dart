import 'package:clean_arch_app/domain/entities/stock/stock_take.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/stock/stock_model.dart';
import '../stock_view_model.dart';

class StockAdjustmentDialog extends StatefulWidget {
  final StockModel stock;
  final bool isEditMode;

  const StockAdjustmentDialog({
    Key? key,
    required this.stock,
    this.isEditMode = false,
  }) : super(key: key);

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
    if (widget.isEditMode) {
      _nameController.text = widget.stock.name;
      _descriptionController.text = widget.stock.description ?? '';
      _priceController.text = widget.stock.price.toString();
      _reorderPointController.text = widget.stock.reorderPoint.toString();
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
    final viewModel = Provider.of<StockViewModel>(context);

    if (!viewModel.canAdjustStock && !widget.isEditMode) {
      return AlertDialog(
        title: Text('Permission Denied'),
        content: Text('You do not have permission to adjust stock quantities.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    }

    if (widget.isEditMode && !viewModel.canEditStock) {
      return AlertDialog(
        title: Text('Permission Denied'),
        content: Text('You do not have permission to edit stock items.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildHeader(), _buildContent(), _buildActions()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          Icon(
            widget.isEditMode ? Icons.edit : Icons.inventory_2,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.isEditMode
                      ? 'Edit Stock Item'
                      : 'Adjust Stock: ${widget.stock.name}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!widget.isEditMode)
                  Text(
                    'Current Quantity: ${widget.stock.quantity} ${widget.stock.unit}',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: widget.isEditMode ? _buildEditForm() : _buildAdjustmentForm(),
    );
  }

  Widget _buildEditForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: _nameController,
          decoration: InputDecoration(
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
        SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Description (Optional)',
            prefixIcon: Icon(Icons.description),
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
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
            SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _reorderPointController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
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
          children: [
            Expanded(
              child: RadioListTile<AdjustmentType>(
                title: Text('Add'),
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
                title: Text('Remove'),
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
        ),
        SizedBox(height: 16),
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
            suffixText: widget.stock.unit,
            border: OutlineInputBorder(),
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
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _reasonController,
          decoration: InputDecoration(
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
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
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
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          SizedBox(width: 12),
          ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            child: _isLoading
                ? SizedBox(
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

    return 'New quantity will be: $newQuantity ${widget.stock.unit}';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final viewModel = Provider.of<StockViewModel>(context, listen: false);

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
