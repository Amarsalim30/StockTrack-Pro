import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/injection.dart';
import '../../domain/entities/catalog/product.dart';
import '../../domain/entities/catalog/category.dart';
import '../../domain/entities/catalog/supplier.dart';
import '../../domain/entities/general/unit.dart';

class CatalogTestPage extends ConsumerStatefulWidget {
  const CatalogTestPage({super.key});

  @override
  ConsumerState<CatalogTestPage> createState() => _CatalogTestPageState();
}

class _CatalogTestPageState extends ConsumerState<CatalogTestPage> {
  final List<String> _log = [];
  final ScrollController _scrollController = ScrollController();

  void _addLog(String message) {
    setState(() {
      _log.add('${DateTime.now().toIso8601String().substring(11, 19)}: $message');
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalog Firebase Integration Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: _testCompleteFlow,
                  child: const Text('Test Complete Flow'),
                ),
                ElevatedButton(
                  onPressed: _testCategories,
                  child: const Text('Test Categories'),
                ),
                ElevatedButton(
                  onPressed: _testSuppliers,
                  child: const Text('Test Suppliers'),
                ),
                ElevatedButton(
                  onPressed: _testUnits,
                  child: const Text('Test Units'),
                ),
                ElevatedButton(
                  onPressed: _testProducts,
                  child: const Text('Test Products'),
                ),
                ElevatedButton(
                  onPressed: () => setState(() => _log.clear()),
                  child: const Text('Clear Log'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _log.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      _log[index],
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _testCompleteFlow() async {
    _addLog('🚀 Starting complete catalog flow test...');

    // Test in order: Units -> Categories -> Suppliers -> Products
    await _testUnits();
    await _testCategories();
    await _testSuppliers();
    await _testProducts();

    _addLog('✅ Complete flow test finished!');
  }

  Future<void> _testCategories() async {
    _addLog('📁 Testing Category Repository...');
    final repository = ref.read(categoryRepositoryProvider);

    try {
      // Create category
      const testCategory = Category(
        id: '',
        name: 'Electronics',
        description: 'Electronic devices and components',
      );

      final createResult = await repository.createCategory(testCategory);
      createResult.fold(
        (error) => _addLog('❌ Create Category Error: $error'),
        (category) => _addLog('✅ Created Category: ${category.name} (ID: ${category.id})'),
      );

      // Get all categories
      final getAllResult = await repository.getAllCategories();
      getAllResult.fold(
        (error) => _addLog('❌ Get All Categories Error: $error'),
        (categories) => _addLog('📋 Found ${categories.length} categories'),
      );

      // Search categories
      final searchResult = await repository.searchCategories('Elec');
      searchResult.fold(
        (error) => _addLog('❌ Search Categories Error: $error'),
        (categories) => _addLog('🔍 Search found ${categories.length} categories'),
      );

    } catch (e) {
      _addLog('💥 Category test exception: $e');
    }
  }

  Future<void> _testSuppliers() async {
    _addLog('🏪 Testing Supplier Repository...');
    final repository = ref.read(supplierRepositoryProvider);

    try {
      // Create supplier with all fields
      const testSupplier = Supplier(
        id: '',
        name: 'TechCorp Industries',
        contactInfo: {
          'email': 'contact@techcorp.com',
          'phone': '+1-555-0123',
          'website': 'https://techcorp.com'
        },
        rating: 4.5,
        isActive: true,
        address: '123 Tech Street, Silicon Valley, CA 94043',
        paymentTerms: 'Net 30',
      );

      final createResult = await repository.createSupplier(testSupplier);
      createResult.fold(
        (error) => _addLog('❌ Create Supplier Error: $error'),
        (supplier) => _addLog('✅ Created Supplier: ${supplier.name} (Active: ${supplier.isActive})'),
      );

      // Get all suppliers
      final getAllResult = await repository.getAllSuppliers();
      getAllResult.fold(
        (error) => _addLog('❌ Get All Suppliers Error: $error'),
        (suppliers) => _addLog('📋 Found ${suppliers.length} suppliers'),
      );

      // Get active suppliers
      final activeResult = await repository.getActiveSuppliers();
      activeResult.fold(
        (error) => _addLog('❌ Get Active Suppliers Error: $error'),
        (suppliers) => _addLog('🟢 Found ${suppliers.length} active suppliers'),
      );

    } catch (e) {
      _addLog('💥 Supplier test exception: $e');
    }
  }

  Future<void> _testUnits() async {
    _addLog('📏 Testing Unit Repository...');
    final repository = ref.read(unitRepositoryProvider);

    try {
      // Create unit
      const testUnit = Unit(
        id: '',
        name: 'Pieces',
        description: 'Individual countable items',
        conversionRate: 1.0,
      );

      final createResult = await repository.createUnit(testUnit);
      createResult.fold(
        (error) => _addLog('❌ Create Unit Error: $error'),
        (unit) => _addLog('✅ Created Unit: ${unit.name} (Rate: ${unit.conversionRate})'),
      );

      // Get all units
      final getAllResult = await repository.getAllUnits();
      getAllResult.fold(
        (error) => _addLog('❌ Get All Units Error: $error'),
        (units) => _addLog('📋 Found ${units.length} units'),
      );

      // Search units
      final searchResult = await repository.searchUnits('Piece');
      searchResult.fold(
        (error) => _addLog('❌ Search Units Error: $error'),
        (units) => _addLog('🔍 Search found ${units.length} units'),
      );

    } catch (e) {
      _addLog('💥 Unit test exception: $e');
    }
  }

  Future<void> _testProducts() async {
    _addLog('📦 Testing Product Repository...');
    final repository = ref.read(productRepositoryProvider);

    try {
      // Create product with all fields
      const testProduct = Product(
        id: '',
        name: 'Arduino Uno R3',
        sku: 'ARD-UNO-R3-001',
        description: 'Microcontroller board based on ATmega328P',
        categoryId: 'electronics-category-id',
        supplierId: 'techcorp-supplier-id',
        price: 25.99,
        costPrice: 18.50,
        tags: ['arduino', 'microcontroller', 'electronics', 'development'],
      );

      final createResult = await repository.createProduct(testProduct);
      createResult.fold(
        (error) => _addLog('❌ Create Product Error: $error'),
        (product) => _addLog('✅ Created Product: ${product.name} (SKU: ${product.sku}, Price: \$${product.price})'),
      );

      // Get all products
      final getAllResult = await repository.getAllProducts();
      getAllResult.fold(
        (error) => _addLog('❌ Get All Products Error: $error'),
        (products) => _addLog('📋 Found ${products.length} products'),
      );

      // Search products
      final searchResult = await repository.searchProducts('Arduino');
      searchResult.fold(
        (error) => _addLog('❌ Search Products Error: $error'),
        (products) => _addLog('🔍 Search found ${products.length} products'),
      );

      // Get products by category
      final categoryResult = await repository.getProductsByCategory('electronics-category-id');
      categoryResult.fold(
        (error) => _addLog('❌ Get Products by Category Error: $error'),
        (products) => _addLog('📁 Found ${products.length} products in category'),
      );

      // Get products by supplier
      final supplierResult = await repository.getProductsBySupplierId('techcorp-supplier-id');
      supplierResult.fold(
        (error) => _addLog('❌ Get Products by Supplier Error: $error'),
        (products) => _addLog('🏪 Found ${products.length} products from supplier'),
      );

    } catch (e) {
      _addLog('💥 Product test exception: $e');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}