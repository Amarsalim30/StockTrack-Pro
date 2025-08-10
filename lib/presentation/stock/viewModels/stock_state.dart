import 'package:clean_arch_app/domain/entities/auth/permission_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../domain/entities/stock/stock.dart';
import '../../../domain/entities/auth/user.dart';
import '../../../core/enums/stock_status.dart';

part 'stock_state.freezed.dart';

@freezed
class StockState with _$StockState {
  const StockState._();

  const factory StockState({
    @Default([]) List<Stock> stocks,
    @Default([]) List<Stock> filteredStocks,
    User? currentUser,
    @Default(StockStateStatus.initial) StockStateStatus status,
    @Default({}) Set<String> selectedStockIds,
    @Default('') String searchQuery,
    StockStatus? filterStatus,
    @Default(SortBy.name) SortBy sortBy,
    @Default(SortOrder.ascending) SortOrder sortOrder,
    @Default(false) bool isBulkSelectionMode,
    String? errorMessage,
  }) = _StockState;

  // Computed getters for permissions
  bool get canCreate => currentUser?.hasPermission(PermissionType.createProduct) ?? false;
  bool get canEdit => currentUser?.hasPermission(PermissionType.editProduct) ?? false;
  bool get canDelete => currentUser?.hasPermission(PermissionType.deleteProduct) ?? false;
  bool get canAdjust => currentUser?.hasPermission(PermissionType.adjustStock) ?? false;
  bool get canViewReports => currentUser?.hasPermission(PermissionType.viewReports) ?? false;

// Other computed properties if needed
}
