import 'package:equatable/equatable.dart';
import '../../../domain/entities/catalog/product.dart';
import 'product_filter_dialog.dart';

enum ProductLoadingState {
  idle,
  loading,
  creating,
  updating,
  deleting,
  searching,
  bulk,
  importing,
  exporting,
  validating,
}

enum ProductSortOption {
  name,
  sku,
  createdDate,
  updatedDate,
  price,
  category,
  supplier,
}

enum SortDirection { ascending, descending }

class ProductState extends Equatable {
  final ProductLoadingState loadingState;
  final List<Product> products;
  final List<Product> allProducts;
  final String? error;
  final String searchQuery;
  final ProductFilterOptions? filters;
  final String? deletingProductId;
  final List<String> selectedProductIds;
  final ProductSortOption sortOption;
  final SortDirection sortDirection;
  final bool showInactiveProducts;
  final Product? selectedProduct;
  final String? csvTemplate;
  final String? csvValidationError;
  final int? csvImportProgress;
  final int? csvTotalRows;

  const ProductState({
    this.loadingState = ProductLoadingState.idle,
    this.products = const [],
    this.allProducts = const [],
    this.error,
    this.searchQuery = '',
    this.filters,
    this.deletingProductId,
    this.selectedProductIds = const [],
    this.sortOption = ProductSortOption.name,
    this.sortDirection = SortDirection.ascending,
    this.showInactiveProducts = false,
    this.selectedProduct,
    this.csvTemplate,
    this.csvValidationError,
    this.csvImportProgress,
    this.csvTotalRows,
  });

  // Computed properties
  bool get hasError => error != null && error!.isNotEmpty;
  bool get hasFilters => filters?.hasFilters ?? false;
  bool get isLoading => loadingState != ProductLoadingState.idle;
  bool get isCreating => loadingState == ProductLoadingState.creating;
  bool get isUpdating => loadingState == ProductLoadingState.updating;
  bool get isDeleting => loadingState == ProductLoadingState.deleting;
  bool get isSearching => loadingState == ProductLoadingState.searching;
  bool get isBulkOperating => loadingState == ProductLoadingState.bulk;
  bool get isImporting => loadingState == ProductLoadingState.importing;
  bool get isExporting => loadingState == ProductLoadingState.exporting;
  bool get isValidating => loadingState == ProductLoadingState.validating;
  bool get hasSelectedProducts => selectedProductIds.isNotEmpty;
  bool get hasProducts => products.isNotEmpty;
  bool get hasCsvValidationError =>
      csvValidationError != null && csvValidationError!.isNotEmpty;
  double get csvImportProgressPercentage =>
      csvTotalRows != null && csvTotalRows! > 0
      ? (csvImportProgress ?? 0) / csvTotalRows!
      : 0.0;

  bool isProductDeleting(String productId) =>
      isDeleting && deletingProductId == productId;

  bool isProductSelected(String productId) =>
      selectedProductIds.contains(productId);

  // Business logic methods
  List<Product> get filteredAndSortedProducts {
    List<Product> result = List.from(products);

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      result = result.where((product) {
        return product.name.toLowerCase().contains(queryLower) ||
            product.sku.toLowerCase().contains(queryLower) ||
            (product.description?.toLowerCase().contains(queryLower) ?? false);
      }).toList();
    }

    // Apply filters
    if (filters != null) {
      if (filters!.categoryId != null) {
        result = result
            .where((p) => p.categoryId == filters!.categoryId)
            .toList();
      }
      if (filters!.supplierId != null) {
        result = result
            .where((p) => p.supplierId == filters!.supplierId)
            .toList();
      }
      if (filters!.unitId != null) {
        result = result.where((p) => p.unitId == filters!.unitId).toList();
      }
      if (filters!.minPrice != null) {
        result = result
            .where((p) => p.price != null && p.price! >= filters!.minPrice!)
            .toList();
      }
      if (filters!.maxPrice != null) {
        result = result
            .where((p) => p.price != null && p.price! <= filters!.maxPrice!)
            .toList();
      }
      if (!showInactiveProducts) {
        result = result.where((p) => p.isActive).toList();
      }
    }

    // Apply sorting
    result.sort((a, b) {
      int comparison;
      switch (sortOption) {
        case ProductSortOption.name:
          comparison = a.name.compareTo(b.name);
          break;
        case ProductSortOption.sku:
          comparison = a.sku.compareTo(b.sku);
          break;
        case ProductSortOption.createdDate:
          comparison = (a.createdAt ?? DateTime.now()).compareTo(
            b.createdAt ?? DateTime.now(),
          );
          break;
        case ProductSortOption.updatedDate:
          comparison = (a.updatedAt ?? DateTime.now()).compareTo(
            b.updatedAt ?? DateTime.now(),
          );
          break;
        case ProductSortOption.price:
          comparison = (a.price ?? 0.0).compareTo(b.price ?? 0.0);
          break;
        case ProductSortOption.category:
          comparison = a.categoryId.compareTo(b.categoryId);
          break;
        case ProductSortOption.supplier:
          comparison = a.supplierId.compareTo(b.supplierId);
          break;
      }
      return sortDirection == SortDirection.ascending
          ? comparison
          : -comparison;
    });

    return result;
  }

  int get selectedProductsCount => selectedProductIds.length;
  int get totalProductsCount => allProducts.length;
  int get activeProductsCount => allProducts.where((p) => p.isActive).length;
  int get inactiveProductsCount => allProducts.where((p) => !p.isActive).length;

  ProductState copyWith({
    ProductLoadingState? loadingState,
    List<Product>? products,
    List<Product>? allProducts,
    String? error,
    String? searchQuery,
    ProductFilterOptions? filters,
    String? deletingProductId,
    List<String>? selectedProductIds,
    ProductSortOption? sortOption,
    SortDirection? sortDirection,
    bool? showInactiveProducts,
    Product? selectedProduct,
    String? csvTemplate,
    String? csvValidationError,
    int? csvImportProgress,
    int? csvTotalRows,
  }) {
    return ProductState(
      loadingState: loadingState ?? this.loadingState,
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
      deletingProductId: deletingProductId,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
      sortOption: sortOption ?? this.sortOption,
      sortDirection: sortDirection ?? this.sortDirection,
      showInactiveProducts: showInactiveProducts ?? this.showInactiveProducts,
      selectedProduct: selectedProduct,
      csvTemplate: csvTemplate ?? this.csvTemplate,
      csvValidationError: csvValidationError,
      csvImportProgress: csvImportProgress,
      csvTotalRows: csvTotalRows,
    );
  }

  @override
  List<Object?> get props => [
    loadingState,
    products,
    allProducts,
    error,
    searchQuery,
    filters,
    deletingProductId,
    selectedProductIds,
    sortOption,
    sortDirection,
    showInactiveProducts,
    selectedProduct,
  ];
}
