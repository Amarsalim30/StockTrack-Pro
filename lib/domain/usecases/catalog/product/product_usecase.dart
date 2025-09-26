import 'package:dartz/dartz.dart';
import '../../../entities/catalog/product.dart';
import '../../../repositories/product_repository.dart';
import '../../../../core/error/failures.dart';

/// Base UseCase interface for Product operations
abstract class ProductUseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Get all products
class GetAllProductsUseCase implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetAllProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(void params) =>
      repository.getAllProducts();
}

/// Get product by ID
class GetProductByIdUseCase implements ProductUseCase<Product, String> {
  final ProductRepository repository;
  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(String id) =>
      repository.getProductById(id);
}

/// Create new product
class CreateProductUseCase implements ProductUseCase<Product, Product> {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(Product product) =>
      repository.createProduct(product);
}

/// Update existing product
class UpdateProductUseCase implements ProductUseCase<Product, Product> {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Failure, Product>> call(Product product) =>
      repository.updateProduct(product);
}

/// Delete product
class DeleteProductUseCase implements ProductUseCase<void, String> {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String id) => repository.deleteProduct(id);
}

/// Search products
class SearchProductsUseCase implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String query) =>
      repository.searchProducts(query);
}

/// Get products by category
class GetProductsByCategoryUseCase
    implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String categoryId) =>
      repository.getProductsByCategory(categoryId);
}

/// Get products by supplier
class GetProductsBySupplierUseCase
    implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  GetProductsBySupplierUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String supplierId) =>
      repository.getProductsBySupplierId(supplierId);
}

/// Get products by unit
class GetProductsByUnitUseCase
    implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  GetProductsByUnitUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String unitId) =>
      repository.getProductsByUnitId(unitId);
}

/// Get active products
class GetActiveProductsUseCase implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetActiveProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(void params) =>
      repository.getActiveProducts();
}

/// Get inactive products
class GetInactiveProductsUseCase
    implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetInactiveProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(void params) =>
      repository.getInactiveProducts();
}

/// Low stock products
class GetLowStockProductsUseCase
    implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetLowStockProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(void params) =>
      repository.getLowStockProducts();
}

/// Out of stock products
class GetOutOfStockProductsUseCase
    implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetOutOfStockProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(void params) =>
      repository.getOutOfStockProducts();
}

/// Get products by price range
class GetProductsByPriceRangeParams {
  final double? minPrice;
  final double? maxPrice;

  GetProductsByPriceRangeParams({this.minPrice, this.maxPrice});
}

class GetProductsByPriceRangeUseCase
    implements ProductUseCase<List<Product>, GetProductsByPriceRangeParams> {
  final ProductRepository repository;
  GetProductsByPriceRangeUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(
    GetProductsByPriceRangeParams params,
  ) => repository.getProductsByPriceRange(
    minPrice: params.minPrice,
    maxPrice: params.maxPrice,
  );
}

/// Check if SKU exists
class IsSkuExistsParams {
  final String sku;
  final String? excludeProductId;

  IsSkuExistsParams(this.sku, {this.excludeProductId});
}

class IsSkuExistsUseCase implements ProductUseCase<bool, IsSkuExistsParams> {
  final ProductRepository repository;
  IsSkuExistsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(IsSkuExistsParams params) => repository
      .isSkuExists(params.sku, excludeProductId: params.excludeProductId);
}

/// Create multiple products
class CreateMultipleProductsUseCase
    implements ProductUseCase<List<Product>, List<Product>> {
  final ProductRepository repository;
  CreateMultipleProductsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(List<Product> products) =>
      repository.createMultipleProducts(products);
}

/// Delete multiple products
class DeleteMultipleProductsUseCase
    implements ProductUseCase<void, List<String>> {
  final ProductRepository repository;
  DeleteMultipleProductsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(List<String> productIds) =>
      repository.deleteMultipleProducts(productIds);
}

/// Export products to CSV
class ExportProductsToCsvUseCase
    implements ProductUseCase<String, List<Product>> {
  final ProductRepository repository;
  ExportProductsToCsvUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(List<Product> products) =>
      repository.exportProductsToCsv(products);
}

/// Import products from CSV
class ImportProductsFromCsvUseCase
    implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  ImportProductsFromCsvUseCase(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(String csvContent) =>
      repository.importProductsFromCsv(csvContent);
}

/// Validate CSV format
class ValidateCsvFormatUseCase implements ProductUseCase<bool, String> {
  final ProductRepository repository;
  ValidateCsvFormatUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(String csvContent) =>
      repository.validateCsvFormat(csvContent);
}

/// Get CSV template
class GetCsvTemplateUseCase implements ProductUseCase<String, void> {
  final ProductRepository repository;
  GetCsvTemplateUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(void params) =>
      repository.getCsvTemplate();
}
