import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/injection.dart';
import 'product/product_state.dart';
import 'product/product_view_model.dart';
import 'products_tab.dart';
import 'categories_tab.dart';
import 'suppliers_tab.dart';

class ProductCatalogPage extends ConsumerStatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  ConsumerState<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends ConsumerState<ProductCatalogPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Product Catalog',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0E2330),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: const [
            Tab(icon: Icon(Icons.inventory_2, size: 20), text: 'Products'),
            Tab(icon: Icon(Icons.category, size: 20), text: 'Categories'),
            Tab(icon: Icon(Icons.business, size: 20), text: 'Suppliers'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ProductsTab(), CategoriesTab(), SuppliersTab()],
      ),
    );
  }
}
