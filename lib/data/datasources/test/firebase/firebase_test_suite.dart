import 'dart:typed_data';
// import 'auth/firebase_auth_test_data_source.dart'; // Commented out until testing phase
import 'firestore/firestore_test_data_source.dart';
import 'storage/firebase_storage_test_data_source.dart';
import 'messaging/firebase_messaging_test_data_source.dart';

/// Complete Firebase test suite with all services
class FirebaseTestSuite {
  // late final FirebaseAuthTestDataSource auth; // Commented out until testing phase
  late final FirestoreTestDataSource firestore;
  late final FirebaseStorageTestDataSource storage;
  late final FirebaseMessagingTestDataSource messaging;

  FirebaseTestSuite() {
    // auth = FirebaseAuthTestDataSource(); // Commented out until testing phase
    firestore = FirestoreTestDataSource();
    storage = FirebaseStorageTestDataSource();
    messaging = FirebaseMessagingTestDataSource();
  }

  /// Initialize all services
  Future<void> initialize() async {
    await messaging.initialize();
    // Other services initialize themselves
  }

  /// Reset all test data
  void resetAll() {
    // // auth.clearMockUsers(); // Commented out until testing phase
    firestore.clearAllCollections();
    storage.clearAllFiles();
    messaging.clearMessageHistory();
  }

  /// Dispose all resources
  void dispose() {
    firestore.dispose();
    messaging.dispose();
  }

  /// Setup common test data
  void setupTestData() {
    // Add test users - commented out until testing phase
    // auth.addMockUser({
    //   'id': 'admin_user',
    //   'email': 'admin@test.com',
    //   'password': 'admin123',
    //   'name': 'Admin User',
    //   'role': 'admin',
    // });

    // auth.addMockUser({
    //   'id': 'manager_user',
    //   'email': 'manager@test.com',
    //   'password': 'manager123',
    //   'name': 'Manager User',
    //   'role': 'manager',
    // });

    // auth.addMockUser({
    //   'id': 'staff_user',
    //   'email': 'staff@test.com',
    //   'password': 'staff123',
    //   'name': 'Staff User',
    //   'role': 'staff',
    // });

    // Add test products
    firestore.addMockData('products', [
      {
        'id': 'product_1',
        'name': 'Test Product 1',
        'sku': 'TEST001',
        'categoryId': 'category_1',
        'supplierId': 'supplier_1',
        'costPrice': 100.0,
        'sellingPrice': 150.0,
        'isActive': true,
      },
      {
        'id': 'product_2',
        'name': 'Test Product 2',
        'sku': 'TEST002',
        'categoryId': 'category_2',
        'supplierId': 'supplier_2',
        'costPrice': 200.0,
        'sellingPrice': 300.0,
        'isActive': true,
      },
    ]);

    // Add test categories
    firestore.addMockData('categories', [
      {
        'id': 'category_1',
        'name': 'Electronics',
        'description': 'Electronic items',
        'isActive': true,
      },
      {
        'id': 'category_2',
        'name': 'Office Supplies',
        'description': 'Office related items',
        'isActive': true,
      },
    ]);

    // Add test suppliers
    firestore.addMockData('suppliers', [
      {
        'id': 'supplier_1',
        'name': 'Supplier One',
        'email': 'supplier1@test.com',
        'phone': '+1234567890',
        'address': '123 Test Street',
        'isActive': true,
      },
      {
        'id': 'supplier_2',
        'name': 'Supplier Two',
        'email': 'supplier2@test.com',
        'phone': '+0987654321',
        'address': '456 Test Avenue',
        'isActive': true,
      },
    ]);

    // Add test stock data
    firestore.addMockData('stocks', [
      {
        'id': 'stock_1',
        'productId': 'product_1',
        'quantity': 100,
        'reservedQuantity': 10,
        'minQuantity': 20,
        'maxQuantity': 500,
        'location': 'Warehouse A',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
      {
        'id': 'stock_2',
        'productId': 'product_2',
        'quantity': 50,
        'reservedQuantity': 5,
        'minQuantity': 10,
        'maxQuantity': 200,
        'location': 'Warehouse B',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    ]);
  }

  /// Get test credentials
  Map<String, Map<String, String>> get testCredentials => {
    'admin': {
      'email': 'admin@test.com',
      'password': 'admin123',
    },
    'manager': {
      'email': 'manager@test.com',
      'password': 'manager123',
    },
    'staff': {
      'email': 'staff@test.com',
      'password': 'staff123',
    },
  };

  /// Check if all services are working
  Future<bool> healthCheck() async {
    try {
      // Test auth - commented out until testing phase
      // await auth.login('admin@test.com', 'admin123');
      
      // Test firestore
      await firestore.addDocument('test', {'test': true});
      
      // Test storage
      await storage.uploadFile('test.txt', Uint8List.fromList([72, 101, 108, 108, 111])); // "Hello"
      
      // Test messaging
      await messaging.getToken();
      
      return true;
    } catch (e) {
      return false;
    }
  }
}