import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/catalog/product.dart';
import '../../../domain/usecases/catalog/product/product_usecases.dart';
import '../../../domain/usecases/catalog/product/product_usecase.dart';
import '../../../core/utils/debouncer.dart';
import 'product_state.dart';
import 'product_filter_dialog.dart';

class ProductViewModel extends StateNotifier<ProductState> {
  final ProductUseCases useCases;
  final Debouncer _searchDebouncer = Debouncer(milliseconds: 300);

  ProductViewModel(this.useCases) : super(const ProductState()) {
    fetchAllProducts();
  }

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }

  // Core CRUD operations
  Future<void> fetchAllProducts() async {
    state = state.copyWith(
      loadingState: ProductLoadingState.loading,
      error: null,
    );

    try {
      final result = await useCases.getAll.call(null);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to fetch products',
        ),
        (products) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            allProducts: products,
            products: products,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> addProduct(Product product) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.creating,
      error: null,
    );

    try {
      final result = await useCases.create.call(product);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to create product',
        ),
        (_) async {
          state = state.copyWith(loadingState: ProductLoadingState.idle);
          await fetchAllProducts(); // Refresh the list
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> updateProduct(Product product) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.updating,
      error: null,
    );

    try {
      final result = await useCases.update.call(product);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to update product',
        ),
        (_) async {
          state = state.copyWith(loadingState: ProductLoadingState.idle);
          await fetchAllProducts(); // Refresh the list
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> deleteProduct(String id) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.deleting,
      deletingProductId: id,
      error: null,
    );

    try {
      final result = await useCases.delete.call(id);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          deletingProductId: null,
          error: failure.message ?? 'Failed to delete product',
        ),
        (_) async {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            deletingProductId: null,
          );
          await fetchAllProducts(); // Refresh the list
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        deletingProductId: null,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  // Search and filtering
  void updateSearch(String value) {
    state = state.copyWith(searchQuery: value);
    _searchDebouncer.run(() {
      _updateFilteredProducts();
    });
  }

  Future<void> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      await fetchAllProducts();
      return;
    }

    state = state.copyWith(
      loadingState: ProductLoadingState.searching,
      searchQuery: query,
      error: null,
    );

    try {
      final result = await useCases.search.call(query);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to search products',
        ),
        (products) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            allProducts: products,
            products: products,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  void applyFilters(ProductFilterOptions? filters) {
    state = state.copyWith(filters: filters);
    _updateFilteredProducts();
  }

  void clearFilters() {
    state = state.copyWith(filters: null);
    _updateFilteredProducts();
  }

  // Sorting
  void setSortOption(ProductSortOption sortOption) {
    if (state.sortOption == sortOption) {
      // Toggle sort direction if same option
      final newDirection = state.sortDirection == SortDirection.ascending
          ? SortDirection.descending
          : SortDirection.ascending;
      state = state.copyWith(sortDirection: newDirection);
    } else {
      state = state.copyWith(
        sortOption: sortOption,
        sortDirection: SortDirection.ascending,
      );
    }
    _updateFilteredProducts();
  }

  // Selection management
  void toggleProductSelection(String productId) {
    final selectedIds = List<String>.from(state.selectedProductIds);
    if (selectedIds.contains(productId)) {
      selectedIds.remove(productId);
    } else {
      selectedIds.add(productId);
    }
    state = state.copyWith(selectedProductIds: selectedIds);
  }

  void selectAllProducts() {
    final allIds = state.filteredAndSortedProducts.map((p) => p.id).toList();
    state = state.copyWith(selectedProductIds: allIds);
  }

  void clearSelection() {
    state = state.copyWith(selectedProductIds: []);
  }

  // Bulk operations
  Future<void> deleteSelectedProducts() async {
    if (state.selectedProductIds.isEmpty) return;

    state = state.copyWith(loadingState: ProductLoadingState.bulk, error: null);

    try {
      final result = await useCases.deleteMultiple.call(
        state.selectedProductIds,
      );
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to delete selected products',
        ),
        (_) async {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            selectedProductIds: [],
          );
          await fetchAllProducts(); // Refresh the list
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> createMultipleProducts(List<Product> products) async {
    state = state.copyWith(loadingState: ProductLoadingState.bulk, error: null);

    try {
      final result = await useCases.createMultiple.call(products);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to create products',
        ),
        (_) async {
          state = state.copyWith(loadingState: ProductLoadingState.idle);
          await fetchAllProducts(); // Refresh the list
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  // Filter by category/supplier/unit
  Future<void> filterByCategory(String categoryId) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.loading,
      error: null,
    );

    try {
      final result = await useCases.getByCategory.call(categoryId);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to fetch products by category',
        ),
        (products) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            allProducts: products,
            products: products,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> filterBySupplier(String supplierId) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.loading,
      error: null,
    );

    try {
      final result = await useCases.getBySupplier.call(supplierId);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to fetch products by supplier',
        ),
        (products) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            allProducts: products,
            products: products,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> filterByPriceRange(double? minPrice, double? maxPrice) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.loading,
      error: null,
    );

    try {
      final params = GetProductsByPriceRangeParams(
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      final result = await useCases.getByPriceRange.call(params);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to fetch products by price range',
        ),
        (products) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            allProducts: products,
            products: products,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  // Status management
  void toggleShowInactiveProducts() {
    state = state.copyWith(showInactiveProducts: !state.showInactiveProducts);
    _updateFilteredProducts();
  }

  Future<void> fetchActiveProducts() async {
    state = state.copyWith(
      loadingState: ProductLoadingState.loading,
      error: null,
    );

    try {
      final result = await useCases.getActive.call(null);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to fetch active products',
        ),
        (products) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            allProducts: products,
            products: products,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  // SKU validation
  Future<bool> checkSkuExists(String sku, {String? excludeProductId}) async {
    try {
      final params = IsSkuExistsParams(sku, excludeProductId: excludeProductId);
      final result = await useCases.isSkuExists.call(params);
      return result.fold(
        (_) => false, // On error, assume doesn't exist
        (exists) => exists,
      );
    } catch (e) {
      return false; // On error, assume doesn't exist
    }
  }

  // Product selection
  void selectProduct(Product product) {
    state = state.copyWith(selectedProduct: product);
  }

  void clearSelectedProduct() {
    state = state.copyWith(selectedProduct: null);
  }

  // CSV Operations
  Future<void> exportProductsToCsv(List<Product> products) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.exporting,
      error: null,
    );

    try {
      final result = await useCases.exportToCsv.call(products);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to export products to CSV',
        ),
        (csvContent) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            csvTemplate: csvContent,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> importProductsFromCsv(String csvContent) async {
    state = state.copyWith(
      loadingState: ProductLoadingState.importing,
      error: null,
      csvValidationError: null,
    );

    try {
      // First validate the CSV format
      final validationResult = await useCases.validateCsv.call(csvContent);
      final isValid = validationResult.fold((failure) {
        state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          csvValidationError: failure.message ?? 'CSV validation failed',
        );
        return false;
      }, (valid) => valid);

      if (!isValid) return;

      // Parse products from CSV
      final parseResult = await useCases.importFromCsv.call(csvContent);
      parseResult.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to parse CSV content',
        ),
        (products) async {
          // Create products in batches
          final batchSize = 10;
          final totalBatches = (products.length / batchSize).ceil();

          for (int i = 0; i < totalBatches; i++) {
            final start = i * batchSize;
            final end = (start + batchSize).clamp(0, products.length);
            final batch = products.sublist(start, end);

            state = state.copyWith(
              csvImportProgress: start,
              csvTotalRows: products.length,
            );

            await createMultipleProducts(batch);
          }

          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            csvImportProgress: null,
            csvTotalRows: null,
          );
          await fetchAllProducts(); // Refresh the list
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<void> getCsvTemplate() async {
    state = state.copyWith(
      loadingState: ProductLoadingState.validating,
      error: null,
    );

    try {
      final result = await useCases.getCsvTemplate.call(null);
      result.fold(
        (failure) => state = state.copyWith(
          loadingState: ProductLoadingState.idle,
          error: failure.message ?? 'Failed to get CSV template',
        ),
        (template) {
          state = state.copyWith(
            loadingState: ProductLoadingState.idle,
            csvTemplate: template,
            error: null,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        loadingState: ProductLoadingState.idle,
        error: 'Unexpected error occurred: $e',
      );
    }
  }

  Future<bool> validateCsvContent(String csvContent) async {
    try {
      final result = await useCases.validateCsv.call(csvContent);
      return result.fold(
        (failure) {
          state = state.copyWith(
            csvValidationError: failure.message ?? 'CSV validation failed',
          );
          return false;
        },
        (valid) {
          state = state.copyWith(csvValidationError: null);
          return valid;
        },
      );
    } catch (e) {
      state = state.copyWith(
        csvValidationError: 'Unexpected error occurred: $e',
      );
      return false;
    }
  }

  void clearCsvValidationError() {
    state = state.copyWith(csvValidationError: null);
  }

  void clearCsvTemplate() {
    state = state.copyWith(csvTemplate: null);
  }

  // Error handling
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Private helper methods
  void _updateFilteredProducts() {
    // The filtering is now handled by the state's computed property
    // This method triggers a state update to recompute filtered products
    state = state.copyWith(products: state.allProducts);
  }
}
