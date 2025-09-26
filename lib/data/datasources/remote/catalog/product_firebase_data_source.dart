import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../models/catalog/product_model.dart';
import '../../../../core/error/failures.dart';

abstract class ProductFirebaseDataSource {
  Future<Either<Failure, List<ProductModel>>> getAllProducts();
  Future<Either<Failure, ProductModel>> getProductById(String id);
  Future<Either<Failure, ProductModel>> createProduct(ProductModel product);
  Future<Either<Failure, ProductModel>> updateProduct(ProductModel product);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, List<ProductModel>>> searchProducts(String query);
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String categoryId);
  Future<Either<Failure, List<ProductModel>>> getProductsBySupplierId(String supplierId);
  Future<Either<Failure, List<ProductModel>>> getProductsByUnitId(String unitId);
  Future<Either<Failure, List<ProductModel>>> getActiveProducts();
  Future<Either<Failure, List<ProductModel>>> getInactiveProducts();
  Future<Either<Failure, List<ProductModel>>> getProductsByPriceRange({
    double? minPrice,
    double? maxPrice,
  });
  Future<Either<Failure, bool>> isSkuExists(String sku, {String? excludeProductId});
  Future<Either<Failure, List<ProductModel>>> createMultipleProducts(List<ProductModel> products);
  Future<Either<Failure, void>> deleteMultipleProducts(List<String> productIds);
}

class ProductFirebaseDataSourceImpl implements ProductFirebaseDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'products';

  ProductFirebaseDataSourceImpl(this._firestore);

  @override
  Future<Either<Failure, List<ProductModel>>> getAllProducts() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .orderBy('created_at', descending: true)
          .get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        return const Left(ServerFailure(message: 'Product not found'));
      }
      final product = _parseProductFromDocument(doc);
      return Right(product);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> createProduct(ProductModel product) async {
    try {
      // Create product for Firebase (with timestamps)
      final productData = product.forCreation().toJson()..remove('id');
      final docRef = await _firestore.collection(_collection).add(productData);

      // Return the created product with the new ID
      final createdProduct = product.copyWith(
        id: docRef.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return Right(createdProduct);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ProductModel>> updateProduct(ProductModel product) async {
    try {
      // Update product with new timestamp
      final updatedProduct = product.forUpdate();
      final productData = updatedProduct.toJson()..remove('id');

      await _firestore.collection(_collection).doc(product.id).update(productData);
      return Right(updatedProduct);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete product: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts(String query) async {
    try {
      // Search by name, SKU, or description
      final queryLower = query.toLowerCase();

      // Get all products and filter client-side for more flexible search
      // This is because Firestore doesn't support OR queries or full-text search
      final snapshot = await _firestore.collection(_collection).get();
      final allProducts = _parseProductsFromSnapshot(snapshot);

      final filteredProducts = allProducts.where((product) {
        return product.name.toLowerCase().contains(queryLower) ||
               product.sku.toLowerCase().contains(queryLower) ||
               (product.description?.toLowerCase().contains(queryLower) ?? false);
      }).toList();

      return Right(filteredProducts);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to search products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('categoryId', isEqualTo: categoryId)
          .orderBy('name')
          .get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch products by category: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsBySupplierId(String supplierId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('supplierId', isEqualTo: supplierId)
          .orderBy('name')
          .get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch products by supplier: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByUnitId(String unitId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('unitId', isEqualTo: unitId)
          .orderBy('name')
          .get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch products by unit: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getActiveProducts() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch active products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getInactiveProducts() async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('isActive', isEqualTo: false)
          .orderBy('name')
          .get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch inactive products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByPriceRange({
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore.collection(_collection);

      if (minPrice != null) {
        query = query.where('price', isGreaterThanOrEqualTo: minPrice);
      }
      if (maxPrice != null) {
        query = query.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await query.orderBy('price').get();
      final products = _parseProductsFromSnapshot(snapshot);
      return Right(products);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch products by price range: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isSkuExists(String sku, {String? excludeProductId}) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_collection)
          .where('sku', isEqualTo: sku);

      final snapshot = await query.get();

      if (excludeProductId != null) {
        // Check if any product with this SKU exists excluding the specified product
        final existingProducts = snapshot.docs
            .where((doc) => doc.id != excludeProductId)
            .toList();
        return Right(existingProducts.isNotEmpty);
      }

      return Right(snapshot.docs.isNotEmpty);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to check SKU existence: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<ProductModel>>> createMultipleProducts(List<ProductModel> products) async {
    try {
      final batch = _firestore.batch();
      final List<ProductModel> createdProducts = [];

      for (final product in products) {
        final docRef = _firestore.collection(_collection).doc();
        final productData = product.forCreation().toJson()..remove('id');
        batch.set(docRef, productData);

        createdProducts.add(product.copyWith(
          id: docRef.id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ));
      }

      await batch.commit();
      return Right(createdProducts);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to create multiple products: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMultipleProducts(List<String> productIds) async {
    try {
      final batch = _firestore.batch();

      for (final productId in productIds) {
        final docRef = _firestore.collection(_collection).doc(productId);
        batch.delete(docRef);
      }

      await batch.commit();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to delete multiple products: ${e.toString()}'));
    }
  }

  // Helper methods
  List<ProductModel> _parseProductsFromSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs.map(_parseProductFromDocument).toList();
  }

  ProductModel _parseProductFromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ProductModel.fromJson({...data, 'id': doc.id});
  }
}