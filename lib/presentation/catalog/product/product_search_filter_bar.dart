import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import '../../../di/injection.dart';
import 'product_state.dart';
import 'product_view_model.dart';
import 'product_filter_dialog.dart';

class ProductSearchFilterBar extends ConsumerWidget {
  const ProductSearchFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: vm.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search products by name, SKU, or description...',
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: productsState.searchQuery.isNotEmpty
                        ? IconButton(
                            onPressed: () => vm.updateSearch(''),
                            icon: const Icon(Icons.clear, color: Colors.grey),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color(0xFF0E2330),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Filter Button
              OutlinedButton.icon(
                onPressed: () => _showFilterDialog(context, vm, productsState),
                icon: Icon(
                  Icons.filter_list,
                  color: productsState.hasFilters
                      ? const Color(0xFF0E2330)
                      : Colors.grey,
                ),
                label: Text(
                  'Filter',
                  style: TextStyle(
                    color: productsState.hasFilters
                        ? const Color(0xFF0E2330)
                        : Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: productsState.hasFilters
                        ? const Color(0xFF0E2330)
                        : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),

          // Active Filters and Sort Options
          if (productsState.hasFilters ||
              productsState.searchQuery.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildActiveFiltersAndSort(context, vm, productsState),
          ],
        ],
      ),
    );
  }

  Widget _buildActiveFiltersAndSort(
    BuildContext context,
    ProductViewModel vm,
    ProductState state,
  ) {
    return Row(
      children: [
        // Active Filters
        if (state.hasFilters) ...[
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (state.filters?.categoryId != null)
                  _buildFilterChip(
                    label: 'Category: ${state.filters!.categoryId}',
                    onDeleted: () => _removeCategoryFilter(vm, state),
                  ),
                if (state.filters?.supplierId != null)
                  _buildFilterChip(
                    label: 'Supplier: ${state.filters!.supplierId}',
                    onDeleted: () => _removeSupplierFilter(vm, state),
                  ),
                if (state.filters?.unitId != null)
                  _buildFilterChip(
                    label: 'Unit: ${state.filters!.unitId}',
                    onDeleted: () => _removeUnitFilter(vm, state),
                  ),
                if (state.filters?.minPrice != null ||
                    state.filters?.maxPrice != null)
                  _buildFilterChip(
                    label:
                        'Price: ${state.filters!.minPrice ?? 0} - ${state.filters!.maxPrice ?? '∞'}',
                    onDeleted: () => _removePriceFilter(vm, state),
                  ),
                _buildFilterChip(
                  label: 'Clear All Filters',
                  onDeleted: () => vm.clearFilters(),
                  isClearAll: true,
                ),
              ],
            ),
          ),
        ] else ...[
          const Expanded(child: SizedBox()),
        ],

        // Sort Options
        Row(
          children: [
            Text(
              'Sort by:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<ProductSortOption>(
              value: state.sortOption,
              onChanged: (value) {
                if (value != null) {
                  vm.setSortOption(value);
                }
              },
              underline: const SizedBox(),
              items: ProductSortOption.values.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    _getSortOptionLabel(option),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => vm.setSortOption(state.sortOption),
              icon: Icon(
                state.sortDirection == SortDirection.ascending
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                size: 20,
                color: const Color(0xFF0E2330),
              ),
              tooltip: 'Toggle sort direction',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onDeleted,
    bool isClearAll = false,
  }) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isClearAll ? Colors.red : const Color(0xFF0E2330),
        ),
      ),
      onDeleted: onDeleted,
      deleteIcon: Icon(
        Icons.close,
        size: 16,
        color: isClearAll ? Colors.red : const Color(0xFF0E2330),
      ),
      backgroundColor: isClearAll
          ? Colors.red.shade50
          : const Color(0xFF0E2330).withOpacity(0.1),
      side: BorderSide(
        color: isClearAll ? Colors.red : const Color(0xFF0E2330),
        width: 1,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getSortOptionLabel(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.name:
        return 'Name';
      case ProductSortOption.sku:
        return 'SKU';
      case ProductSortOption.createdDate:
        return 'Created Date';
      case ProductSortOption.updatedDate:
        return 'Updated Date';
      case ProductSortOption.price:
        return 'Price';
      case ProductSortOption.category:
        return 'Category';
      case ProductSortOption.supplier:
        return 'Supplier';
    }
  }

  void _showFilterDialog(
    BuildContext context,
    ProductViewModel vm,
    ProductState state,
  ) {
    showDialog(
      context: context,
      builder: (context) => ProductFilterDialog(currentFilters: state.filters),
    );
  }

  void _removeCategoryFilter(ProductViewModel vm, ProductState state) {
    final newFilters = state.filters?.copyWith(categoryId: null);
    vm.applyFilters(newFilters);
  }

  void _removeSupplierFilter(ProductViewModel vm, ProductState state) {
    final newFilters = state.filters?.copyWith(supplierId: null);
    vm.applyFilters(newFilters);
  }

  void _removeUnitFilter(ProductViewModel vm, ProductState state) {
    final newFilters = state.filters?.copyWith(unitId: null);
    vm.applyFilters(newFilters);
  }

  void _removePriceFilter(ProductViewModel vm, ProductState state) {
    final newFilters = state.filters?.copyWith(minPrice: null, maxPrice: null);
    vm.applyFilters(newFilters);
  }
}
