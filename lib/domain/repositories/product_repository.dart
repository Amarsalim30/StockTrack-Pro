import 'package:dartz/dartz.dart';
import '../entities/catalog/product.dart';
import '../../core/error/failures.dart';

abstract class ProductRepository {
  /// Get all products
  Future<Either<Failure, List<Product>>> getAllProducts();

  /// Get product by ID
  Future<Either<Failure, Product>> getProductById(String id);

  /// Create new product
  Future<Either<Failure, Product>> createProduct(Product product);

  /// Update existing product
  Future<Either<Failure, Product>> updateProduct(Product product);

  /// Delete product by ID
  Future<Either<Failure, void>> deleteProduct(String id);

  /// Search products by name, SKU, or description
  Future<Either<Failure, List<Product>>> searchProducts(String query);

  /// Get products by category ID
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId);

  /// Get products by supplier ID
  Future<Either<Failure, List<Product>>> getProductsBySupplierId(String supplierId);

  /// Get products by unit ID
  Future<Either<Failure, List<Product>>> getProductsByUnitId(String unitId);

  /// Get active products only
  Future<Either<Failure, List<Product>>> getActiveProducts();

  /// Get inactive products
  Future<Either<Failure, List<Product>>> getInactiveProducts();

  /// Get products with low stock (requires stock integration)
  Future<Either<Failure, List<Product>>> getLowStockProducts();

  /// Get products that are out of stock (requires stock integration)
  Future<Either<Failure, List<Product>>> getOutOfStockProducts();

  /// Get products with price range filter
  Future<Either<Failure, List<Product>>> getProductsByPriceRange({
    double? minPrice,
    double? maxPrice,
  });

  /// Check if SKU exists
  Future<Either<Failure, bool>> isSkuExists(String sku, {String? excludeProductId});

  /// Bulk operations
  Future<Either<Failure, List<Product>>> createMultipleProducts(List<Product> products);
  Future<Either<Failure, void>> deleteMultipleProducts(List<String> productIds);
}
