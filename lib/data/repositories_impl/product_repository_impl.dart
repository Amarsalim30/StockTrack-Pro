import 'package:dartz/dartz.dart';
import '../../core/error/Exceptions.dart';
import '../../domain/entities/catalog/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_api.dart';
import '../mappers/catalog/product_mapper.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApi api;

  ProductRepositoryImpl(this.api);

  @override
  Future<Either<Exception, List<Product>>> getAllProducts() async {
    try {
      final models = await api.getAllProducts();
      final products = models.map((model) => ProductMapper.toEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Product>> getProductById(String id) async {
    try {
      final model = await api.getProductById(id);
      final product = ProductMapper.toEntity(model);
      return Right(product);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Product>> createProduct(Product product) async {
    try {
      final model = ProductMapper.fromEntity(product);
      final createdModel = await api.createProduct(model);
      final createdProduct = ProductMapper.toEntity(createdModel);
      return Right(createdProduct);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, Product>> updateProduct(Product product) async {
    try {
      final model = ProductMapper.fromEntity(product);
      final updatedModel = await api.updateProduct( model);
      final updatedProduct = ProductMapper.toEntity(updatedModel);
      return Right(updatedProduct);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, void>> deleteProduct(String id) async {
    try {
      await api.deleteProduct(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> searchProducts(String query) async {
    try {
      final models = await api.searchProducts(query);
      final products = models.map((model) => ProductMapper.toEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getProductsByCategory(String categoryId) async {
    try {
      final models = await api.getProductsByCategory(categoryId);
      final products = models.map((model) => ProductMapper.toEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getProductsBySupplierId(String supplierId) async {
    try {
      final models = await api.getProductsBySupplier(supplierId);
      final products = models.map((model) => ProductMapper.toEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getLowStockProducts() async {
    try {
      final models = await api.getLowStockProducts();
      final products = models.map((model) => ProductMapper.toEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getOutOfStockProducts() async {
    try {
      final models = await api.getOutOfStockProducts();
      final products = models.map((model) => ProductMapper.toEntity(model)).toList();
      return Right(products);
    } on ServerException catch (e) {
      return Left(ServerException(e.message));
    } catch (e) {
      return Left(ServerException('Unexpected error: ${e.toString()}'));
    }
  }
}