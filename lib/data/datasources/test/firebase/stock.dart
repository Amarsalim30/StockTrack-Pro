import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../domain/entities/stock/stock.dart';
import '../../../../core/enums/stock_status.dart';

class StockFirebaseDatasource {
  final   FirebaseFirestore _firestore;

  StockFirebaseDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Get all stocks
  Future<List<Stock>> fetchStocks() async {
    final snapshot = await _firestore.collection('stocks').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Stock(
        id: doc.id,
        name: data['name'] ?? '',
        sku: data['sku'] ?? '',
        quantity: data['quantity'] ?? 0,
        status: StockStatus.inStock, // Default status
        durabilityType: StockDurabilityType.nonPerishable, // Default durability
        categoryId: data['categoryId'],
        location: data['location'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
      );
    }).toList();
  }

  /// Get a single stock by ID
  Future<Stock?> fetchStockById(String id) async {
    final doc = await _firestore.collection('stocks').doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    return Stock(
      id: doc.id,
      name: data['name'] ?? '',
      sku: data['sku'] ?? '',
      quantity: data['quantity'] ?? 0,
      status: StockStatus.inStock, // Default status
      durabilityType: StockDurabilityType.nonPerishable, // Default durability
      categoryId: data['categoryId'],
      location: data['location'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(data['updatedAt'] ?? DateTime.now().millisecondsSinceEpoch),
    );
  }

  /// Add new stock
  Future<void> addStock(Stock stock) async {
    await _firestore.collection('stocks').add({
      'name': stock.name,
      'sku': stock.sku,
      'categoryId': stock.categoryId,
      'location': stock.location,
    });
  }

  /// Update stock
  Future<void> updateStock(Stock stock) async {
    if (stock.id == null) throw Exception("Stock ID is required to update");
    await _firestore.collection('stocks').doc(stock.id).update({
      'name': stock.name,
      'sku': stock.sku,
      'categoryId': stock.categoryId,
      'location': stock.location,
    });
  }

  /// Delete stock
  Future<void> deleteStock(String id) async {
    await _firestore.collection('stocks').doc(id).delete();
  }
}
