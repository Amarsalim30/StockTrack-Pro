import 'package:dartz/dartz.dart';
import 'package:clean_arch_app/core/error/Exceptions.dart';
import 'package:clean_arch_app/data/datasources/remote/product_api.dart';
import 'package:clean_arch_app/data/mappers/catalog/product_mapper.dart';
import 'package:clean_arch_app/domain/entities/catalog/product.dart';
import 'package:clean_arch_app/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApi api;

  ProductRepositoryImpl(this.api);

  @override
  Future<Either<Exception, List<Product>>> getAllProducts() async {
    try {
      final productModels = await api.getAllProducts();
      final products = productModels.map(ProductMapper.toEntity).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Exception, Product>> getProductById(String id) async {
    try {
      final productModel = await api.getProductById(id);
      return Right(ProductMapper.toEntity(productModel));
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to fetch product: $e'));
    }
  }

  @override
  Future<Either<Exception, Product>> createProduct(Product product) async {
    try {
      final productModel = ProductMapper.fromEntity(product);
      final createdModel = await api.createProduct(productModel);
      return Right(ProductMapper.toEntity(createdModel));
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to create product: $e'));
    }
  }

  @override
  Future<Either<Exception, Product>> updateProduct(Product product) async {
    try {
      final productModel = ProductMapper.fromEntity(product);
      await api.updateProduct(productModel);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteProduct(String id) async {
    try {
      await api.deleteProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> searchProducts(String query) async {
    try {
      final productModels = await api.searchProducts(query);
      final products = productModels.map(ProductMapper.toEntity).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to search products: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getProductsByCategory(String category) async {
    try {
      final productModels = await api.getProductsByCategory(category);
      final products = productModels.map(ProductMapper.toEntity).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to fetch products by category: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getProductsBySupplierId(String supplierId) async {
    try {
      final productModels = await api.getProductsBySupplier(supplierId);
      final products = productModels.map(ProductMapper.toEntity).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to fetch products by supplier: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getLowStockProducts() async {
    try {
      final productModels = await api.getLowStockProducts();
      final products = productModels.map(ProductMapper.toEntity).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to fetch low stock products: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getOutOfStockProducts() async {
    try {
      final productModels = await api.getOutOfStockProducts();
      final products = productModels.map(ProductMapper.toEntity).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message ?? 'Server error'));
    } catch (e) {
      return Left(ServerException('Failed to fetch out-of-stock products: $e'));
    }
  }
}
