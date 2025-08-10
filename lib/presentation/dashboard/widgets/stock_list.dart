// lib/presentation/dashboard/widgets/stock_list.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:clean_arch_app/core/enums/stock_status.dart';
import '../../../domain/entities/stock/stock.dart';
import '../../../core/constants/colors.dart';

/// Production-ready responsive StockList with enhanced UX
/// Features:
/// - Adaptive layout (desktop table/mobile cards)
/// - Bulk selection with haptic feedback
/// - Swipe actions and confirmation dialogs
/// - Loading skeletons and empty states
/// - Accessibility support
/// - Performance optimizations
class StockList extends StatefulWidget {
  final List<Stock> stocks;
  final bool isLoading;
  final String? emptyMessage;
  final String? searchQuery;
  final Future<void> Function()? onRefresh;
  final void Function(Stock stock, String action)? onAction;
  final void Function(Stock stock)? onTap;
  final void Function(Set<Stock> selected)? onSelectionChanged;
  final void Function(List<Stock> stocks)? onBulkAction;
  final bool enableBulkActions;
  final Widget? floatingActionButton;

  const StockList({
    super.key,
    required this.stocks,
    this.isLoading = false,
    this.emptyMessage,
    this.searchQuery,
    this.onRefresh,
    this.onAction,
    this.onTap,
    this.onSelectionChanged,
    this.onBulkAction,
    this.enableBulkActions = true,
    this.floatingActionButton,
  });

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> with TickerProviderStateMixin {
  final Set<Stock> _selected = <Stock>{};
  final ScrollController _scrollController = ScrollController();
  late AnimationController _selectionAnimationController;
  late Animation<double> _selectionAnimation;
  
  // Responsive breakpoints
  static const double _mobileBreakpoint = 600;
  static const double _tabletBreakpoint = 900;
  static const double _desktopBreakpoint = 1200;
  
  // Column widths for desktop table
  static const double _checkboxColumnWidth = 56;
  static const double _nameColumnWidth = 200;
  static const double _skuColumnWidth = 140;
  static const double _quantityColumnWidth = 100;
  static const double _statusColumnWidth = 120;
  static const double _locationColumnWidth = 160;
  static const double _actionsColumnWidth = 120;

  @override
  void initState() {
    super.initState();
    _selectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _selectionAnimation = CurvedAnimation(
      parent: _selectionAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _selectionAnimationController.dispose();
    super.dispose();
  }

  bool get _isAllSelected => _selected.length == widget.stocks.length && widget.stocks.isNotEmpty;
  bool get _hasSelection => _selected.isNotEmpty;
  
  void _toggleSelectAll(bool? v) {
    HapticFeedback.selectionClick();
    setState(() {
      if (v == true) {
        _selected.addAll(widget.stocks);
        _selectionAnimationController.forward();
      } else {
        _selected.clear();
        _selectionAnimationController.reverse();
      }
      widget.onSelectionChanged?.call(_selected);
    });
  }
  final Set<String> _selectedIds = {};

  void _toggleItemSelection(Stock item, bool? v) {
    HapticFeedback.selectionClick();
    setState(() {
      final id = item.id ?? item.hashCode.toString();
      if (v == true) {
        _selectedIds.add(id);
        if (_selectedIds.length == 1) _selectionAnimationController.forward();
      } else {
        _selectedIds.remove(id);
        if (_selectedIds.isEmpty) _selectionAnimationController.reverse();
      }
      // notify parent with actual Stock instances
      final selectedStocks = widget.stocks.where((s) => _selectedIds.contains(s.id)).toSet();
      widget.onSelectionChanged?.call(selectedStocks);
    });
  }


  void _clearSelection() {
    setState(() {
      _selected.clear();
      _selectionAnimationController.reverse();
      widget.onSelectionChanged?.call(_selected);
    });
  }

  DeviceType _getDeviceType(double width) {
    if (width < _mobileBreakpoint) return DeviceType.mobile;
    if (width < _tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return _buildLoadingState();
    }

    if (widget.stocks.isEmpty) {
      return _buildEmptyState();
    }

    return LayoutBuilder(builder: (context, constraints) {
      final deviceType = _getDeviceType(constraints.maxWidth);
      
      return Column(
        children: [
          // Bulk action bar
          if (_hasSelection && widget.enableBulkActions)
            _buildBulkActionBar(),
          
          // Main content
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildContentForDevice(deviceType, constraints),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildContentForDevice(DeviceType deviceType, BoxConstraints constraints) {
    switch (deviceType) {
      case DeviceType.desktop:
        return _buildDesktopTable(constraints);
      case DeviceType.tablet:
        return _buildTabletGrid();
      case DeviceType.mobile:
        return _buildMobileList();
    }
  }

  // ---------------- Bulk Action Bar ----------------
  Widget _buildBulkActionBar() {
    return AnimatedBuilder(
      animation: _selectionAnimation,
      builder: (context, child) {
        return Transform.translateY(
          offset: Offset(0, -60 * (1 - _selectionAnimation.value)),
          child: Container(
            height: 60,
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.slate?[50] ?? Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.slate?[200] ?? Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  LucideIcons.check_square,
                  color: AppColors.slate?[600] ?? Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${_selected.length} item${_selected.length == 1 ? '' : 's'} selected',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.slate?[800] ?? Colors.grey[800],
                  ),
                ),
                const Spacer(),
                _buildBulkActionButton(
                  'Export',
                  LucideIcons.download,
                  () => _handleBulkAction('export'),
                ),
                const SizedBox(width: 8),
                _buildBulkActionButton(
                  'Delete',
                  LucideIcons.trash_2,
                  () => _handleBulkAction('delete'),
                  isDestructive: true,
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _clearSelection,
                  icon: const Icon(LucideIcons.x, size: 18),
                  tooltip: 'Clear selection',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBulkActionButton(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    final color = isDestructive ? Colors.red : AppColors.slate?[600] ?? Colors.grey[600];
    
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 16, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _handleBulkAction(String action) async {
    HapticFeedback.mediumImpact();
    
    if (action == 'delete') {
      final confirmed = await _showBulkDeleteConfirmation();
      if (!confirmed) return;
    }
    
    widget.onBulkAction?.call(_selected.toList());
    _clearSelection();
  }

  Future<bool> _showBulkDeleteConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Selected Items'),
        content: Text(
          'Are you sure you want to delete ${_selected.length} item${_selected.length == 1 ? '' : 's'}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  // ---------------- Desktop Table ----------------
  Widget _buildDesktopTable(BoxConstraints constraints) {
    final totalWidth = _checkboxColumnWidth +
        _nameColumnWidth +
        _skuColumnWidth +
        _quantityColumnWidth +
        _statusColumnWidth +
        _locationColumnWidth +
        _actionsColumnWidth;
    
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: AppColors.slate?[50] ?? Colors.grey[50],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: AppColors.slate?[200] ?? Colors.grey[300]!),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  SizedBox(width: _checkboxColumnWidth, child: _buildHeaderCheckbox()),
                  SizedBox(width: _nameColumnWidth, child: _buildHeaderCell('Product Name')),
                  SizedBox(width: _skuColumnWidth, child: _buildHeaderCell('SKU')),
                  SizedBox(width: _quantityColumnWidth, child: _buildHeaderCell('Quantity', align: TextAlign.center)),
                  SizedBox(width: _statusColumnWidth, child: _buildHeaderCell('Status', align: TextAlign.center)),
                  SizedBox(width: _locationColumnWidth, child: _buildHeaderCell('Location')),
                  SizedBox(width: _actionsColumnWidth, child: _buildHeaderCell('Actions', align: TextAlign.center)),
                ],
              ),
            ),
          ),
          
          // Content
          Expanded(
            child: Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              child: RefreshIndicator.adaptive(
                onRefresh: widget.onRefresh ?? () async {},
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.stocks.length,
                  itemBuilder: (context, index) {
                    final stock = widget.stocks[index];
                    return _buildDesktopRow(stock, index);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCheckbox() {
    return Checkbox(
      value: _isAllSelected,
      tristate: _hasSelection && !_isAllSelected,
      onChanged: _toggleSelectAll,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      activeColor: AppColors.slate?[600] ?? Colors.blue,
    );
  }

  Widget _buildHeaderCell(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 13,
        color: AppColors.slate?[700] ?? Colors.grey[700],
        letterSpacing: 0.5,
      ),
      textAlign: align,
    );
  }

  Widget _buildDesktopRow(Stock stock, int index) {
    final isSelected = _selected.contains(stock);
    final status = _getStockStatus(stock);
    
    return InkWell(
      onTap: () => widget.onTap?.call(stock),
      hoverColor: AppColors.slate?[50]?.withOpacity(0.5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected 
            ? AppColors.slate?[100]?.withOpacity(0.5) ?? Colors.blue.withOpacity(0.05)
            : (index.isEven ? Colors.transparent : AppColors.slate?[25] ?? Colors.grey.withOpacity(0.02)),
          border: Border(
            bottom: BorderSide(
              color: AppColors.slate?[100] ?? Colors.grey[200]!,
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: _checkboxColumnWidth,
              child: Checkbox(
                value: isSelected,
                onChanged: (v) => _toggleItemSelection(stock, v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                activeColor: AppColors.slate?[600] ?? Colors.blue,
              ),
            ),
            SizedBox(
              width: _nameColumnWidth,
              child: _buildProductNameCell(stock),
            ),
            SizedBox(
              width: _skuColumnWidth,
              child: _buildSkuCell(stock),
            ),
            SizedBox(
              width: _quantityColumnWidth,
              child: _buildQuantityCell(stock),
            ),
            SizedBox(
              width: _statusColumnWidth,
              child: _buildStatusCell(status),
            ),
            SizedBox(
              width: _locationColumnWidth,
              child: _buildLocationCell(stock),
            ),
            SizedBox(
              width: _actionsColumnWidth,
              child: _buildDesktopActions(stock),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Tablet Grid ----------------
  Widget _buildTabletGrid() {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: widget.stocks.length,
        itemBuilder: (context, index) {
          final stock = widget.stocks[index];
          return _buildTabletCard(stock);
        },
      ),
    );
  }

  Widget _buildTabletCard(Stock stock) {
    final isSelected = _selected.contains(stock);
    final status = _getStockStatus(stock);
    
    return Card(
      elevation: isSelected ? 4 : 2,
      shadowColor: isSelected ? AppColors.slate?[300] : Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isSelected 
          ? BorderSide(color: AppColors.slate?[300] ?? Colors.blue, width: 2)
          : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => widget.onTap?.call(stock),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with checkbox and status
              Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (v) => _toggleItemSelection(stock, v),
                    activeColor: AppColors.slate?[600] ?? Colors.blue,
                  ),
                  const Spacer(),
                  _buildStatusBadge(status),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Product name
              Text(
                stock.name ?? 'Unknown Product',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 4),
              
              // SKU
              Text(
                'SKU: ${stock.sku ?? 'N/A'}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              const Spacer(),
              
              // Quantity and actions
              Row(
                children: [
                  _buildQuantityDisplay(stock),
                  const Spacer(),
                  _buildTabletActions(stock),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Mobile List ----------------
  Widget _buildMobileList() {
    return RefreshIndicator.adaptive(
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: widget.stocks.length,
        itemBuilder: (context, index) {
          final stock = widget.stocks[index];
          return _buildMobileCard(stock);
        },
      ),
    );
  }

  Widget _buildMobileCard(Stock stock) {
    final isSelected = _selected.contains(stock);
    final status = _getStockStatus(stock);
    
    return Dismissible(
      key: ValueKey(stock.id ?? stock.hashCode),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(LucideIcons.trash_2, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text('Delete', style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
      confirmDismiss: (_) => _showDeleteConfirmation(stock),
      onDismissed: (_) {
        HapticFeedback.mediumImpact();
        widget.onAction?.call(stock, 'delete');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          elevation: isSelected ? 3 : 1,
          shadowColor: isSelected ? AppColors.slate?[300] : Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected 
              ? BorderSide(color: AppColors.slate?[300] ?? Colors.blue, width: 2)
              : BorderSide.none,
          ),
          child: InkWell(
            onTap: () => widget.onTap?.call(stock),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Checkbox with larger touch target
                  SizedBox(
                    width: 48,
                    child: Checkbox(
                      value: isSelected,
                      onChanged: (v) => _toggleItemSelection(stock, v),
                      activeColor: AppColors.slate?[600] ?? Colors.blue,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Product details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stock.name ?? 'Unknown Product',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: 4),
                        
                        Row(
                          children: [
                            Text(
                              'SKU: ${stock.sku ?? 'N/A'}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            
                            if (stock.location != null) ...
                            [
                              const SizedBox(width: 12),
                              Icon(LucideIcons.map_pin, size: 12, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  stock.location!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        
                        const SizedBox(height: 8),
                        
                        Row(
                          children: [
                            _buildQuantityDisplay(stock),
                            const SizedBox(width: 12),
                            _buildStatusBadge(status),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Actions
                  _buildMobileActions(stock),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- Cell Builders ----------------
  Widget _buildProductNameCell(Stock stock) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          stock.name ?? 'Unknown Product',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (stock.description != null) ...
        [
          const SizedBox(height: 2),
          Text(
            stock.description!,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildSkuCell(Stock stock) {
    return Text(
      stock.sku ?? 'N/A',
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 13,
        color: Colors.grey[700],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildQuantityCell(Stock stock) {
    final quantity = stock.quantity;
    final minStock = stock.minimumStock ?? 0;
    final color = _getQuantityColor(quantity, minStock);
    
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          quantity.toString(),
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: color,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCell(StockStatusInfo status) {
    return Center(child: _buildStatusBadge(status));
  }

  Widget _buildLocationCell(Stock stock) {
    return Row(
      children: [
        Icon(
          LucideIcons.map_pin,
          size: 14,
          color: Colors.grey[500],
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            stock.location ?? 'No location',
            style: TextStyle(
              color: stock.location != null ? Colors.grey[700] : Colors.grey[500],
              fontSize: 13,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ---------------- Component Builders ----------------
  Widget _buildStatusBadge(StockStatusInfo status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: status.color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              color: status.color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityDisplay(Stock stock) {
    final quantity = stock.quantity;
    final minStock = stock.minimumStock ?? 0;
    final color = _getQuantityColor(quantity, minStock);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.package, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            quantity.toString(),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Action Builders ----------------
  Widget _buildDesktopActions(Stock stock) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Edit',
          onPressed: () => widget.onAction?.call(stock, 'edit'),
          icon: const Icon(LucideIcons.edit_3, size: 16),
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          padding: const EdgeInsets.all(4),
        ),
        PopupMenuButton<String>(
          tooltip: 'More actions',
          onSelected: (action) => widget.onAction?.call(stock, action),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(LucideIcons.eye, size: 16),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'adjust',
              child: Row(
                children: [
                  Icon(LucideIcons.plus_minus, size: 16),
                  SizedBox(width: 8),
                  Text('Adjust Stock'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'duplicate',
              child: Row(
                children: [
                  Icon(LucideIcons.copy, size: 16),
                  SizedBox(width: 8),
                  Text('Duplicate'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(LucideIcons.trash_2, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
          child: const Icon(LucideIcons.more_horizontal, size: 16),
        ),
      ],
    );
  }

  Widget _buildTabletActions(Stock stock) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () => widget.onAction?.call(stock, 'edit'),
          icon: const Icon(LucideIcons.edit_3, size: 18),
          tooltip: 'Edit',
        ),
        PopupMenuButton<String>(
          onSelected: (action) => widget.onAction?.call(stock, action),
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'view', child: Text('View')),
            const PopupMenuItem(value: 'adjust', child: Text('Adjust')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
          child: const Icon(LucideIcons.more_vertical, size: 18),
        ),
      ],
    );
  }

  Widget _buildMobileActions(Stock stock) {
    return PopupMenuButton<String>(
      onSelected: (action) {
        HapticFeedback.selectionClick();
        widget.onAction?.call(stock, action);
      },
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(LucideIcons.eye, size: 16),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(LucideIcons.edit_3, size: 16),
              SizedBox(width: 8),
              Text('Edit'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'adjust',
          child: Row(
            children: [
              Icon(LucideIcons.plus_minus, size: 16),
              SizedBox(width: 8),
              Text('Adjust Stock'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              Icon(LucideIcons.trash_2, size: 16, color: Colors.red),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          LucideIcons.more_vertical,
          size: 18,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  // ---------------- Empty & Loading States ----------------
  Widget _buildEmptyState() {
    final hasSearch = widget.searchQuery?.isNotEmpty ?? false;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch ? LucideIcons.search_x : LucideIcons.package_x,
              size: 64,
              color: Colors.grey[400],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              hasSearch 
                ? 'No items match your search'
                : (widget.emptyMessage ?? 'No stock items found'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              hasSearch 
                ? 'Try adjusting your search terms'
                : 'Add your first inventory item to get started',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (!hasSearch) ...
            [
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => widget.onAction?.call(
                  Stock(id: '', name: '', quantity: 0),
                  'add',
                ),
                icon: const Icon(LucideIcons.plus, size: 18),
                label: const Text('Add Stock Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.slate?[600] ?? Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 8,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _buildLoadingSkeleton(),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Checkbox skeleton
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Content skeleton
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Container(
                    height: 12,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Status skeleton
            Container(
              height: 24,
              width: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            
            const SizedBox(width: 8),
            
            // Action skeleton
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Utility Methods ----------------
  Color _getQuantityColor(int quantity, int minStock) {
    if (quantity <= 0) return Colors.red[600]!;
    if (quantity <= minStock) return Colors.orange[600]!;
    return Colors.green[600]!;
  }

  StockStatusInfo _getStockStatus(Stock stock) {
    final quantity = stock.quantity;
    final minStock = stock.minimumStock ?? 0;
    
    if (quantity <= 0) {
      return StockStatusInfo(
        label: 'Out of Stock',
        color: Colors.red[600]!,
        priority: 3,
      );
    } else if (quantity <= minStock) {
      return StockStatusInfo(
        label: 'Low Stock',
        color: Colors.orange[600]!,
        priority: 2,
      );
    } else {
      return StockStatusInfo(
        label: 'In Stock',
        color: Colors.green[600]!,
        priority: 1,
      );
    }
  }

  Future<bool> _showDeleteConfirmation(Stock stock) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Item'),
        content: Text(
          'Are you sure you want to delete "${stock.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// ---------------- Supporting Classes ----------------
enum DeviceType { mobile, tablet, desktop }

class StockStatusInfo {
  final String label;
  final Color color;
  final int priority;
  
  const StockStatusInfo({
    required this.label,
    required this.color,
    required this.priority,
  });
}

  
