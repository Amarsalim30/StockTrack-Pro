import 'package:clean_arch_app/domain/entities/order/purchase_order.dart';
import 'package:clean_arch_app/presentation/purchase_order/purchase_order_detail_page.dart';
import 'package:clean_arch_app/presentation/purchase_order/purchase_order_page.dart';
import 'package:clean_arch_app/presentation/reporting/reporting_page.dart';
import 'package:clean_arch_app/presentation/stocktake/stocktake_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../di/injection.dart';
import '../../presentation/auth/login_page.dart';
import '../../presentation/common/widgets/main_scaffold.dart';
import '../../presentation/dashboard/dashboard_page.dart';
import '../../presentation/stock/stock_page.dart';
import '../../presentation/product_form/add_product_page.dart';
import '../../presentation/suppliers/supplier_page.dart';
import '../../presentation/users/user_management_page.dart';
import '../../presentation/settings/settings_page.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: RouteNames.stock,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),

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
            path: RouteNames.purchaseOrders,
            name: RouteNames.purchaseOrders,
            builder: (context, state) => const PurchaseOrdersScreen(),
          ),

          GoRoute(
            path: RouteNames.reports,
            name: RouteNames.reports,
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: '/purchase-orders/:id',
            name: 'purchaseOrderDetail',
            builder: (context, state) {
              final order = state.extra as PurchaseOrder;
              return PurchaseOrderDetailPage(order: order);
            },
          ),

          GoRoute(
            path: RouteNames.stocktake,
            name: RouteNames.stocktake,
            builder: (context, state) => StockTakePage(),
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
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
});
