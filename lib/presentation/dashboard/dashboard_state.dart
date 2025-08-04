class DashboardState {
  final String totalProducts;
  final String lowStockItems;
  final String todaySales;
  final String pendingOrders;
  final bool isLoading;
  final String? error;
  final String? outOfStockItems;
  final String? pendingStockProofs;

  const DashboardState({
    this.totalProducts = '0',
    this.lowStockItems = '0',
    this.todaySales = '\$0',
    this.pendingOrders = '0',
    this.outOfStockItems = '0',
    this.pendingStockProofs = '0',
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    String? totalProducts,
    String? lowStockItems,
    String? todaySales,
    String? pendingOrders,
    bool? isLoading,
    String? error,
  }) {
    return DashboardState(
      totalProducts: totalProducts ?? this.totalProducts,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      todaySales: todaySales ?? this.todaySales,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
