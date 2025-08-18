import 'package:clean_arch_app/domain/entities/catalog/product.dart';
import 'package:clean_arch_app/domain/repositories/product_repository.dart';
import 'package:dartz/dartz.dart';


/// Base UseCase interface
abstract class ProductUseCase<Type, Params> {
  Future<Either<Exception, Type>> call(Params params);
}

/// Get all products
class GetAllProductsUseCase implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetAllProductsUseCase(this.repository);

  @override
  Future<Either<Exception, List<Product>>> call(void params) =>
      repository.getAllProducts();
}

/// Get product by ID
class GetProductByIdUseCase implements ProductUseCase<Product, String> {
  final ProductRepository repository;
  GetProductByIdUseCase(this.repository);

  @override
  Future<Either<Exception, Product>> call(String id) =>
      repository.getProductById(id);
}

/// Create new product
class CreateProductUseCase implements ProductUseCase<Product, Product> {
  final ProductRepository repository;
  CreateProductUseCase(this.repository);

  @override
  Future<Either<Exception, Product>> call(Product product) =>
      repository.createProduct(product);
}

/// Update existing product
class UpdateProductUseCase implements ProductUseCase<Product, Product> {
  final ProductRepository repository;
  UpdateProductUseCase(this.repository);

  @override
  Future<Either<Exception, Product>> call(Product product) =>
      repository.updateProduct(product);
}

/// Delete product
class DeleteProductUseCase implements ProductUseCase<void, String> {
  final ProductRepository repository;
  DeleteProductUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(String id) =>
      repository.deleteProduct(id);
}

/// Search products
class SearchProductsUseCase implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  SearchProductsUseCase(this.repository);

  @override
  Future<Either<Exception, List<Product>>> call(String query) =>
      repository.searchProducts(query);
}

/// Get products by category
class GetProductsByCategoryUseCase implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  GetProductsByCategoryUseCase(this.repository);

  @override
  Future<Either<Exception, List<Product>>> call(String category) =>
      repository.getProductsByCategory(category);
}

/// Get products by supplier
class GetProductsBySupplierUseCase implements ProductUseCase<List<Product>, String> {
  final ProductRepository repository;
  GetProductsBySupplierUseCase(this.repository);

  @override
  Future<Either<Exception, List<Product>>> call(String supplierId) =>
      repository.getProductsBySupplierId(supplierId);
}

/// Low stock products
class GetLowStockProductsUseCase implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetLowStockProductsUseCase(this.repository);

  @override
  Future<Either<Exception, List<Product>>> call(void params) =>
      repository.getLowStockProducts();
}

/// Out of stock products
class GetOutOfStockProductsUseCase implements ProductUseCase<List<Product>, void> {
  final ProductRepository repository;
  GetOutOfStockProductsUseCase(this.repository);

  @override
  Future<Either<Exception, List<Product>>> call(void params) =>
      repository.getOutOfStockProducts();
}
