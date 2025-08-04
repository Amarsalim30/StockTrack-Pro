import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dashboard_state.dart';

class DashboardViewModel extends StateNotifier<DashboardState> {
  Timer? _refreshTimer;

  DashboardViewModel() : super(const DashboardState()) {

    _initializeDashboard();
  }

  get setSearchQuery => null;

  void _initializeDashboard() {
    loadDashboardData();

    // Periodic refresh every 30 seconds
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadDashboardData();
    });
  }

  Future<void> loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(
        totalProducts: '150',
        lowStockItems: '12',
        todaySales: '\$2,450',
        pendingOrders: '8',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load dashboard data',
      );
    }
  }

  // UI navigation triggers
  void addNewProduct() {
    // navigation logic (via context or routing)
  }

  void createNewOrder() {}

  void openFilter() {}

  void toggleSort() {}

  void refreshDashboard() => loadDashboardData();

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void setFilter(String value) {}
}
