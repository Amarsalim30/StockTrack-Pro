import 'package:flutter/material.dart';

import 'categories_tab.dart';
import 'products_tab.dart';
import 'suppliers_tab.dart';
import 'units_tab.dart';

class ManageStockPage extends StatelessWidget {
  const ManageStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF0E2330);
    const indicatorColor = Color(0xFF10B981); // green indicator for active tab
    const unselectedColor = Colors.white70;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Stock"),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: indicatorColor,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: unselectedColor,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
            tabs: const [
              Tab(text: "Products"),
              Tab(text: "Categories"),
              Tab(text: "Units"),
              Tab(text: "Suppliers"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ProductsTab(),
            CategoriesTab(),
            UnitsTab(),
            SuppliersTab(),
          ],
        ),
      ),
    );
  }
}
