import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/auth/login_page.dart';
import '../../presentation/dashboard/dashboard_page.dart';
import '../../presentation/dashboard/dashboard_view_model.dart';
import '../../presentation/stock/stock_page.dart';
import '../../presentation/product_form/add_product_page.dart';
import '../../presentation/suppliers/supplier_page.dart';
import '../../presentation/users/user_management_page.dart';
import '../../presentation/settings/settings_page.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.stock,
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.dashboard,
        name: RouteNames.dashboard,
        builder: (context, state) =>
            DashboardPage(),
      ),
      GoRoute(
        path: RouteNames.stock,
        name: RouteNames.stock,
        builder: (context, state) => StockPage(),
      ),
      GoRoute(
        path: RouteNames.addProduct,
        name: RouteNames.addProduct,
        builder: (context, state) => const AddProductPage(),
      ),
      GoRoute(
        path: RouteNames.suppliers,
        name: RouteNames.suppliers,
        builder: (context, state) => SupplierPage(),
      ),
      GoRoute(
        path: RouteNames.users,
        name: RouteNames.users,
        builder: (context, state) => UserManagementPage(),
      ),
      GoRoute(
        path: RouteNames.settings,
        name: RouteNames.settings,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
});
