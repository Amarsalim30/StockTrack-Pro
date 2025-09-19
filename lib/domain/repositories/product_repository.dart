import 'package:dartz/dartz.dart';
import '../entities/catalog/product.dart';

abstract class ProductRepository {
  Future<Either<Exception, List<Product>>> getAllProducts();

  Future<Either<Exception, Product>> getProductById(String id);

  Future<Either<Exception, Product>> createProduct(Product product);

  Future<Either<Exception, Product>> updateProduct(Product product);

  Future<Either<Exception, void>> deleteProduct(String id);

  Future<Either<Exception, List<Product>>> searchProducts(String query);

  Future<Either<Exception, List<Product>>> getProductsByCategory(
    String category,
  );

  Future<Either<Exception, List<Product>>> getProductsBySupplierId(
    String supplierId,
  );

  Future<Either<Exception, List<Product>>> getLowStockProducts();

  Future<Either<Exception, List<Product>>> getOutOfStockProducts();
}
