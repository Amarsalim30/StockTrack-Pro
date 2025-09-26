import 'product_usecase.dart';

/// Aggregate class containing all Product-related use cases
class ProductUseCases {
  // Core CRUD operations
  final GetAllProductsUseCase getAll;
  final GetProductByIdUseCase getById;
  final CreateProductUseCase create;
  final UpdateProductUseCase update;
  final DeleteProductUseCase delete;

  // Search and filtering
  final SearchProductsUseCase search;
  final GetProductsByCategoryUseCase getByCategory;
  final GetProductsBySupplierUseCase getBySupplier;
  final GetProductsByUnitUseCase getByUnit;
  final GetProductsByPriceRangeUseCase getByPriceRange;

  // Status-based queries
  final GetActiveProductsUseCase getActive;
  final GetInactiveProductsUseCase getInactive;
  final GetLowStockProductsUseCase getLowStock;
  final GetOutOfStockProductsUseCase getOutOfStock;

  // Validation and bulk operations
  final IsSkuExistsUseCase isSkuExists;
  final CreateMultipleProductsUseCase createMultiple;
  final DeleteMultipleProductsUseCase deleteMultiple;

  // CSV operations
  final ExportProductsToCsvUseCase exportToCsv;
  final ImportProductsFromCsvUseCase importFromCsv;
  final ValidateCsvFormatUseCase validateCsv;
  final GetCsvTemplateUseCase getCsvTemplate;

  ProductUseCases({
    required this.getAll,
    required this.getById,
    required this.create,
    required this.update,
    required this.delete,
    required this.search,
    required this.getByCategory,
    required this.getBySupplier,
    required this.getByUnit,
    required this.getByPriceRange,
    required this.getActive,
    required this.getInactive,
    required this.getLowStock,
    required this.getOutOfStock,
    required this.isSkuExists,
    required this.createMultiple,
    required this.deleteMultiple,
    required this.exportToCsv,
    required this.importFromCsv,
    required this.validateCsv,
    required this.getCsvTemplate,
  });
}
