import 'package:dartz/dartz.dart';
import '../../../domain/entities/catalog/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../core/error/failures.dart';
import '../../datasources/remote/catalog/product_firebase_data_source.dart';
import '../../mappers/catalog/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductFirebaseDataSource _firebaseDataSource;

  ProductRepositoryImpl(this._firebaseDataSource);

  @override
  Future<Either<Failure, List<Product>>> getAllProducts() async {
    final result = await _firebaseDataSource.getAllProducts();
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    final result = await _firebaseDataSource.getProductById(id);
    return result.map(ProductMapper.toEntity);
  }

  @override
  Future<Either<Failure, Product>> createProduct(Product product) async {
    // Validate the product before creation
    final validationResult = _validateProduct(product);
    if (validationResult != null) {
      return Left(validationResult);
    }

    // Check if SKU already exists
    final skuCheckResult = await _firebaseDataSource.isSkuExists(product.sku);
    return skuCheckResult.fold(
      (failure) => Left(failure),
      (skuExists) async {
        if (skuExists) {
          return const Left(ValidationFailure(message: 'SKU already exists'));
        }

        final model = ProductMapper.forCreation(product);
        final result = await _firebaseDataSource.createProduct(model);
        return result.map(ProductMapper.toEntity);
      },
    );
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    // Validate the product before update
    final validationResult = _validateProduct(product);
    if (validationResult != null) {
      return Left(validationResult);
    }

    // Check if SKU already exists (excluding current product)
    final skuCheckResult = await _firebaseDataSource.isSkuExists(
      product.sku,
      excludeProductId: product.id,
    );
    return skuCheckResult.fold(
      (failure) => Left(failure),
      (skuExists) async {
        if (skuExists) {
          return const Left(ValidationFailure(message: 'SKU already exists'));
        }

        final model = ProductMapper.forUpdate(product);
        final result = await _firebaseDataSource.updateProduct(model);
        return result.map(ProductMapper.toEntity);
      },
    );
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    return await _firebaseDataSource.deleteProduct(id);
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return const Left(ValidationFailure(message: 'Search query cannot be empty'));
    }

    final result = await _firebaseDataSource.searchProducts(query);
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(String categoryId) async {
    final result = await _firebaseDataSource.getProductsByCategory(categoryId);
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsBySupplierId(String supplierId) async {
    final result = await _firebaseDataSource.getProductsBySupplierId(supplierId);
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByUnitId(String unitId) async {
    final result = await _firebaseDataSource.getProductsByUnitId(unitId);
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, List<Product>>> getActiveProducts() async {
    final result = await _firebaseDataSource.getActiveProducts();
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, List<Product>>> getInactiveProducts() async {
    final result = await _firebaseDataSource.getInactiveProducts();
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts() async {
    // TODO: Implement actual low stock logic by integrating with stock management
    // For now, return active products as placeholder
    return getActiveProducts();
  }

  @override
  Future<Either<Failure, List<Product>>> getOutOfStockProducts() async {
    // TODO: Implement actual out of stock logic by integrating with stock management
    // For now, return empty list as placeholder
    return const Right([]);
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByPriceRange({
    double? minPrice,
    double? maxPrice,
  }) async {
    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      return const Left(ValidationFailure(message: 'Minimum price cannot be greater than maximum price'));
    }

    final result = await _firebaseDataSource.getProductsByPriceRange(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, bool>> isSkuExists(String sku, {String? excludeProductId}) async {
    return await _firebaseDataSource.isSkuExists(sku, excludeProductId: excludeProductId);
  }

  @override
  Future<Either<Failure, List<Product>>> createMultipleProducts(List<Product> products) async {
    // Validate all products
    for (final product in products) {
      final validationResult = _validateProduct(product);
      if (validationResult != null) {
        return Left(validationResult);
      }
    }

    // Check for duplicate SKUs within the batch
    final skus = products.map((p) => p.sku).toList();
    final uniqueSkus = skus.toSet();
    if (skus.length != uniqueSkus.length) {
      return const Left(ValidationFailure(message: 'Duplicate SKUs found in batch'));
    }

    final models = ProductMapper.fromEntityList(products);
    final result = await _firebaseDataSource.createMultipleProducts(models);
    return result.map(ProductMapper.toEntityList);
  }

  @override
  Future<Either<Failure, void>> deleteMultipleProducts(List<String> productIds) async {
    if (productIds.isEmpty) {
      return const Left(ValidationFailure(message: 'Product IDs list cannot be empty'));
    }

    return await _firebaseDataSource.deleteMultipleProducts(productIds);
  }

  // Validation helper
  ValidationFailure? _validateProduct(Product product) {
    if (product.name.trim().isEmpty) {
      return const ValidationFailure(message: 'Product name cannot be empty');
    }
    if (product.sku.trim().isEmpty) {
      return const ValidationFailure(message: 'Product SKU cannot be empty');
    }
    if (product.categoryId.trim().isEmpty) {
      return const ValidationFailure(message: 'Category ID cannot be empty');
    }
    if (product.supplierId.trim().isEmpty) {
      return const ValidationFailure(message: 'Supplier ID cannot be empty');
    }
    if (product.price != null && product.price! < 0) {
      return const ValidationFailure(message: 'Product price cannot be negative');
    }
    if (product.costPrice != null && product.costPrice! < 0) {
      return const ValidationFailure(message: 'Product cost price cannot be negative');
    }
    return null;
  }
}