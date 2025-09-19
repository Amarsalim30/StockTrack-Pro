import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/exceptions.dart';
import '../../models/catalog/product_model.dart';

abstract class FirestoreProductDataSource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel?> getProductById(String id);
  Future<ProductModel> createProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<List<ProductModel>> searchProducts(String query);
  Future<List<ProductModel>> getProductsByCategory(String categoryId);
}

class FirestoreProductDataSourceImpl implements FirestoreProductDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'products';

  FirestoreProductDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch products: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      return ProductModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch product: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final docRef = await _firestore.collection(_collection).add(product.toJson());
      final createdProduct = product.copyWith(id: docRef.id);
      return createdProduct;
    } catch (e) {
      throw ServerException('Failed to create product: ${e.toString()}');
    }
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    try {
      final productId = product.id;
      if (productId == null) {
        throw ServerException('Product ID is required for update');
      }

      await _firestore.collection(_collection).doc(productId).update(product.toJson());
      return product;
    } catch (e) {
      throw ServerException('Failed to update product: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete product: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to search products: ${e.toString()}');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('categoryId', isEqualTo: categoryId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ProductModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch products by category: ${e.toString()}');
    }
  }
}