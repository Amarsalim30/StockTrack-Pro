class ApiEndpoints {
  static const String baseUrl = 'http://localhost:8080/api';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String currentUser = '/auth/current-user';

  // User endpoints
  static const String users = '/users';
  static const String userById = '/users/:id';
  static const String userRoles = '/users/:id/roles';

  // Stock endpoints
  static const String stocks = '/stocks';
  static const String stockById = '/stocks/:id';
  static const String stockMovements = '/stocks/:id/movements';
  static const String stockAdjustments = '/stocks/:id/adjustments';

  // Stock take endpoints
  static const String stockTakes = '/stock-takes';
  static const String stockTakeById = '/stock-takes/:id';
  static const String stockTakeItems = '/stock-takes/:id/items';
  static const String stockTakeItemById = '/stock-takes/:id/items/:itemId';

  // Product endpoints
  static const String products = '/products';
  static const String productById = '/products/:id';
  static const String productCategories = '/categories';

  // Supplier endpoints
  static const String suppliers = '/suppliers';
  static const String supplierById = '/suppliers/:id';

  // Activity endpoints
  static const String activities = '/activities';
  static const String activitiesByEntity = '/activities/entity/:entityId';

  // Reports endpoints
  static const String reports = '/reports';
  static const String reportStockMovement = '/reports/stock-movement';
  static const String reportExpiry = '/reports/expiry';
  static const String reportReorder = '/reports/reorder';
}
