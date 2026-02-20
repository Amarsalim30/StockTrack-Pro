import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../di/injection.dart';
import 'product_state.dart';
import 'product_view_model.dart';
import 'product_filter_dialog.dart';

class ModernSearchFilterBar extends ConsumerStatefulWidget {
  const ModernSearchFilterBar({super.key});

  @override
  ConsumerState<ModernSearchFilterBar> createState() => _ModernSearchFilterBarState();
}

class _ModernSearchFilterBarState extends ConsumerState<ModernSearchFilterBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main search and filter row
          _buildMainSearchRow(context, productsState, vm),

          // Active filters section
          if (productsState.hasFilters || productsState.searchQuery.isNotEmpty)
            _buildActiveFiltersSection(context, productsState, vm),
        ],
      ),
    );
  }

  Widget _buildMainSearchRow(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            child: _buildSearchField(state, vm),
          ),

          const SizedBox(width: 8),

          // View toggle buttons (hidden on mobile)
          if (!isMobile) ...[
            _buildViewToggle(state, vm),
            const SizedBox(width: 8),
          ],

          // Filter button
          _buildFilterButton(context, state, vm),
        ],
      ),
    );
  }

  Widget _buildSearchField(ProductState state, ProductViewModel vm) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isSearchFocused ? Colors.grey.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSearchFocused
              ? const Color(0xFF0E2330)
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: vm.updateSearch,
        onTap: () => setState(() => _isSearchFocused = true),
        onTapOutside: (_) => setState(() => _isSearchFocused = false),
        decoration: InputDecoration(
          hintText: 'Search products, SKU, or description...',
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
          ),
          prefixIcon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: state.isSearching
                ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.grey.shade600,
                        ),
                      ),
                    ),
                  )
                : Icon(
                    Icons.search_rounded,
                    color: _isSearchFocused
                        ? const Color(0xFF0E2330)
                        : Colors.grey.shade500,
                    size: 20,
                  ),
          ),
          suffixIcon: state.searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    vm.updateSearch('');
                  },
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Colors.grey.shade500,
                    size: 20,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(ProductState state, ProductViewModel vm) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewToggleButton(
            icon: Icons.grid_view_rounded,
            isActive: true, // Assuming grid view is default
            onTap: () {
              // Toggle to grid view
            },
          ),
          _buildViewToggleButton(
            icon: Icons.view_list_rounded,
            isActive: false,
            onTap: () {
              // Toggle to list view
            },
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive ? const Color(0xFF0E2330) : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final hasFilters = state.hasFilters;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showFilterDialog(context, state),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: hasFilters ? const Color(0xFF0E2330) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: hasFilters ? Colors.white : Colors.grey.shade600,
              ),
              if (hasFilters) ...[
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getActiveFilterCount(state).toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E2330),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFiltersSection(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            // Search query chip
            if (state.searchQuery.isNotEmpty) ...[
              Row(
                children: [
                  Text(
                    'Search results for:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0E2330).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF0E2330).withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 14,
                            color: const Color(0xFF0E2330),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '"${state.searchQuery}"',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF0E2330),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => vm.updateSearch(''),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Color(0xFF0E2330),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Active filters
            if (state.hasFilters) ...[
              Row(
                children: [
                  Text(
                    'Active filters:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: _buildFilterChips(state, vm),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => vm.clearFilters(),
                    icon: const Icon(Icons.clear_all, size: 16),
                    label: const Text('Clear All'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],

            // Sort section
            _buildSortSection(state, vm),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFilterChips(ProductState state, ProductViewModel vm) {
    final chips = <Widget>[];

    if (state.filters?.categoryId != null) {
      chips.add(_buildFilterChip(
        'Category: ${state.filters!.categoryId}',
        () => _removeCategoryFilter(vm, state),
      ));
    }

    if (state.filters?.supplierId != null) {
      chips.add(_buildFilterChip(
        'Supplier: ${state.filters!.supplierId}',
        () => _removeSupplierFilter(vm, state),
      ));
    }

    if (state.filters?.unitId != null) {
      chips.add(_buildFilterChip(
        'Unit: ${state.filters!.unitId}',
        () => _removeUnitFilter(vm, state),
      ));
    }

    if (state.filters?.minPrice != null || state.filters?.maxPrice != null) {
      chips.add(_buildFilterChip(
        'Price: \$${state.filters!.minPrice ?? 0} - \$${state.filters!.maxPrice ?? '∞'}',
        () => _removePriceFilter(vm, state),
      ));
    }

    return chips;
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 12,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortSection(ProductState state, ProductViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Text(
            'Sort by:',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<ProductSortOption>(
              value: state.sortOption,
              onChanged: (value) {
                if (value != null) {
                  vm.setSortOption(value);
                }
              },
              underline: const SizedBox(),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
              items: ProductSortOption.values.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(_getSortOptionLabel(option)),
                );
              }).toList(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => vm.setSortOption(state.sortOption),
            icon: Icon(
              state.sortDirection == SortDirection.ascending
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: const Color(0xFF0E2330),
            ),
            tooltip: 'Toggle sort direction',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context, ProductState state) {
    showDialog(
      context: context,
      builder: (context) => ProductFilterDialog(currentFilters: state.filters),
    );
  }

  int _getActiveFilterCount(ProductState state) {
    int count = 0;
    if (state.filters?.categoryId != null) count++;
    if (state.filters?.supplierId != null) count++;
    if (state.filters?.unitId != null) count++;
    if (state.filters?.minPrice != null || state.filters?.maxPrice != null) count++;
    return count;
  }

  String _getSortOptionLabel(ProductSortOption option) {
    switch (option) {
      case ProductSortOption.name:
        return 'Name';
      case ProductSortOption.sku:
        return 'SKU';
      case ProductSortOption.createdDate:
        return 'Created';
      case ProductSortOption.updatedDate:
        return 'Updated';
      case ProductSortOption.price:
        return 'Price';
      case ProductSortOption.category:
        return 'Category';
      case ProductSortOption.supplier:
        return 'Supplier';
    }
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