import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductFilterOptions {
  final String? categoryId;
  final String? supplierId;
  final String? unitId;
  final double? minPrice;
  final double? maxPrice;
  final bool? activeOnly;

  const ProductFilterOptions({
    this.categoryId,
    this.supplierId,
    this.unitId,
    this.minPrice,
    this.maxPrice,
    this.activeOnly,
  });

  ProductFilterOptions copyWith({
    String? categoryId,
    String? supplierId,
    String? unitId,
    double? minPrice,
    double? maxPrice,
    bool? activeOnly,
  }) {
    return ProductFilterOptions(
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      unitId: unitId ?? this.unitId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      activeOnly: activeOnly ?? this.activeOnly,
    );
  }

  bool get hasFilters =>
      categoryId != null ||
      supplierId != null ||
      unitId != null ||
      minPrice != null ||
      maxPrice != null ||
      activeOnly != null;

  @override
  String toString() {
    return 'ProductFilterOptions(categoryId: $categoryId, supplierId: $supplierId, unitId: $unitId, minPrice: $minPrice, maxPrice: $maxPrice, activeOnly: $activeOnly)';
  }
}

class ProductFilterDialog extends ConsumerStatefulWidget {
  final ProductFilterOptions? currentFilters;

  const ProductFilterDialog({
    super.key,
    this.currentFilters,
  });

  @override
  ConsumerState<ProductFilterDialog> createState() => _ProductFilterDialogState();
}

class _ProductFilterDialogState extends ConsumerState<ProductFilterDialog> {
  late final TextEditingController _categoryController;
  late final TextEditingController _supplierController;
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.currentFilters?.categoryId ?? '');
    _supplierController = TextEditingController(text: widget.currentFilters?.supplierId ?? '');
    _minPriceController = TextEditingController(text: widget.currentFilters?.minPrice?.toString() ?? '');
    _maxPriceController = TextEditingController(text: widget.currentFilters?.maxPrice?.toString() ?? '');
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _supplierController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(
                labelText: 'Category ID',
                border: OutlineInputBorder(),
                hintText: 'Filter by category',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _supplierController,
              decoration: const InputDecoration(
                labelText: 'Supplier ID',
                border: OutlineInputBorder(),
                hintText: 'Filter by supplier',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Min Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _maxPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Max Price',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _clearFilters,
                  child: const Text('Clear All'),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E2330),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _clearFilters() {
    _categoryController.clear();
    _supplierController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    Navigator.of(context).pop(const ProductFilterOptions());
  }

  void _applyFilters() {
    final filters = ProductFilterOptions(
      categoryId: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      supplierId: _supplierController.text.trim().isEmpty ? null : _supplierController.text.trim(),
      minPrice: _minPriceController.text.trim().isEmpty ? null : double.tryParse(_minPriceController.text.trim()),
      maxPrice: _maxPriceController.text.trim().isEmpty ? null : double.tryParse(_maxPriceController.text.trim()),
    );

    Navigator.of(context).pop(filters);
  }
}