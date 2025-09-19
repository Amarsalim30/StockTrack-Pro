import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/exceptions.dart';
import '../../models/stock/stock_model.dart';

abstract class FirestoreStockDataSource {
  Future<List<StockModel>> getAllStocks();
  Future<StockModel?> getStockById(String id);
  Future<StockModel> createStock(StockModel stock);
  Future<StockModel> updateStock(StockModel stock);
  Future<void> deleteStock(String id);
  Future<List<StockModel>> getStocksByProduct(String productId);
  Future<List<StockModel>> getStocksByLocation(String locationId);
  Future<List<StockModel>> getLowStockItems(int threshold);
}

class FirestoreStockDataSourceImpl implements FirestoreStockDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'stocks';

  FirestoreStockDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<StockModel>> getAllStocks() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return StockModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch stocks: ${e.toString()}');
    }
  }

  @override
  Future<StockModel?> getStockById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      data['id'] = doc.id;
      return StockModel.fromJson(data);
    } catch (e) {
      throw ServerException('Failed to fetch stock: ${e.toString()}');
    }
  }

  @override
  Future<StockModel> createStock(StockModel stock) async {
    try {
      final docRef = await _firestore.collection(_collection).add(stock.toJson());
      final createdStock = stock.copyWith(id: docRef.id);
      return createdStock;
    } catch (e) {
      throw ServerException('Failed to create stock: ${e.toString()}');
    }
  }

  @override
  Future<StockModel> updateStock(StockModel stock) async {
    try {
      final stockId = stock.id;
      if (stockId == null) {
        throw ServerException('Stock ID is required for update');
      }

      await _firestore.collection(_collection).doc(stockId).update(stock.toJson());
      return stock;
    } catch (e) {
      throw ServerException('Failed to update stock: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteStock(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete stock: ${e.toString()}');
    }
  }

  @override
  Future<List<StockModel>> getStocksByProduct(String productId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('productId', isEqualTo: productId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return StockModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch stocks by product: ${e.toString()}');
    }
  }

  @override
  Future<List<StockModel>> getStocksByLocation(String locationId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('location', isEqualTo: locationId)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return StockModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch stocks by location: ${e.toString()}');
    }
  }

  @override
  Future<List<StockModel>> getLowStockItems(int threshold) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('quantity', isLessThanOrEqualTo: threshold)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return StockModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerException('Failed to fetch low stock items: ${e.toString()}');
    }
  }
}