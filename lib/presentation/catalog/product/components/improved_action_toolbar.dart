import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../di/injection.dart';
import '../design_system/product_design_tokens.dart';
import '../design_system/product_theme.dart';
import '../product_state.dart';
import '../product_view_model.dart';

/// Improved Action Toolbar with better UX and accessibility
class ImprovedActionToolbar extends ConsumerWidget {
  const ImprovedActionToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Container(
      margin: ProductDesignTokens.responsivePadding(context),
      child: Column(
        children: [
          // Main action bar
          _buildMainActionBar(context, state, vm),

          // Bulk actions bar (animated slide-in when products are selected)
          AnimatedSize(
            duration: ProductDesignTokens.animationMedium,
            child: state.hasSelectedProducts
                ? _buildBulkActionsBar(context, state, vm)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionBar(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Container(
      padding: const EdgeInsets.all(ProductDesignTokens.spaceLG),
      decoration: ProductTheme.elevatedCardDecoration,
      child: ProductDesignTokens.isMobile(context)
          ? _buildMobileLayout(context, state, vm)
          : _buildDesktopLayout(context, state, vm),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Column(
      children: [
        // Primary action first on mobile
        SizedBox(
          width: double.infinity,
          child: _buildPrimaryButton(context, state, vm),
        ),

        const SizedBox(height: ProductDesignTokens.spaceMD),

        // Secondary actions in grid
        _buildSecondaryActions(context, state, vm),
      ],
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Row(
      children: [
        // Left side - Secondary actions
        Expanded(
          flex: 2,
          child: _buildSecondaryActions(context, state, vm),
        ),

        const SizedBox(width: ProductDesignTokens.spaceLG),

        // Divider
        Container(
          height: 40,
          width: 1,
          color: ProductDesignTokens.borderLight,
        ),

        const SizedBox(width: ProductDesignTokens.spaceLG),

        // Right side - Primary action
        _buildPrimaryButton(context, state, vm),
      ],
    );
  }

  Widget _buildPrimaryButton(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return ElevatedButton.icon(
      onPressed: () => _navigateToAddProduct(context),
      icon: const Icon(Icons.add_circle_outline, size: 20),
      label: const Text('Add Product'),
      style: ProductTheme.primaryButtonTheme.copyWith(
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(
            horizontal: ProductDesignTokens.spaceLG,
            vertical: ProductDesignTokens.spaceMD,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryActions(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final isMobile = ProductDesignTokens.isMobile(context);

    final actions = [
      _buildActionButton(
        context: context,
        label: 'Import',
        icon: Icons.file_upload_outlined,
        isLoading: state.isImporting,
        onPressed: () => _showImportDialog(context, vm),
        tooltip: 'Import products from CSV file',
      ),
      _buildActionButton(
        context: context,
        label: 'Export',
        icon: Icons.file_download_outlined,
        isLoading: state.isExporting,
        isEnabled: state.hasProducts,
        onPressed: () => _showExportDialog(context, vm, state),
        tooltip: 'Export products to CSV file',
      ),
      _buildActionButton(
        context: context,
        label: 'Template',
        icon: Icons.description_outlined,
        isLoading: state.isValidating,
        onPressed: () => _downloadTemplate(vm),
        tooltip: 'Download CSV template',
        isCompact: !isMobile,
      ),
      _buildMoreActionsButton(context, state, vm),
    ];

    if (isMobile) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: ProductDesignTokens.spaceSM,
        crossAxisSpacing: ProductDesignTokens.spaceSM,
        childAspectRatio: 3,
        children: actions,
      );
    }

    return Row(
      children: actions
          .map((action) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: ProductDesignTokens.spaceSM),
                  child: action,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    bool isCompact = false,
    String? tooltip,
  }) {
    final button = OutlinedButton.icon(
      onPressed: isEnabled && !isLoading ? onPressed : null,
      icon: AnimatedSwitcher(
        duration: ProductDesignTokens.animationFast,
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isEnabled ? ProductDesignTokens.primaryColor : ProductDesignTokens.textTertiary,
                  ),
                ),
              )
            : Icon(icon, size: 18),
      ),
      label: isCompact ? const SizedBox.shrink() : Text(label),
      style: ProductTheme.secondaryButtonTheme.copyWith(
        foregroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return ProductDesignTokens.textTertiary;
          }
          return ProductDesignTokens.primaryColor;
        }),
        side: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return const BorderSide(color: ProductDesignTokens.borderLight);
          }
          return BorderSide(
            color: ProductDesignTokens.primaryColor.withOpacity(0.3),
          );
        }),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip,
        child: button,
      );
    }

    return button;
  }

  Widget _buildMoreActionsButton(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMoreAction(context, value, vm, state),
      tooltip: 'More actions',
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'refresh',
          child: ListTile(
            leading: Icon(
              Icons.refresh,
              color: ProductDesignTokens.primaryColor,
              size: 20,
            ),
            title: Text(
              'Refresh',
              style: ProductTheme.getTextStyle(context, 'bodyMedium'),
            ),
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: 'select_all',
          enabled: state.hasProducts,
          child: ListTile(
            leading: Icon(
              Icons.select_all,
              color: state.hasProducts
                  ? ProductDesignTokens.primaryColor
                  : ProductDesignTokens.textTertiary,
              size: 20,
            ),
            title: Text(
              'Select All',
              style: ProductTheme.getTextStyle(context, 'bodyMedium')?.copyWith(
                color: state.hasProducts
                    ? ProductDesignTokens.textPrimary
                    : ProductDesignTokens.textTertiary,
              ),
            ),
            dense: true,
          ),
        ),
        PopupMenuItem(
          value: 'clear_selection',
          enabled: state.hasSelectedProducts,
          child: ListTile(
            leading: Icon(
              Icons.clear,
              color: state.hasSelectedProducts
                  ? ProductDesignTokens.primaryColor
                  : ProductDesignTokens.textTertiary,
              size: 20,
            ),
            title: Text(
              'Clear Selection',
              style: ProductTheme.getTextStyle(context, 'bodyMedium')?.copyWith(
                color: state.hasSelectedProducts
                    ? ProductDesignTokens.textPrimary
                    : ProductDesignTokens.textTertiary,
              ),
            ),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'show_inactive',
          child: ListTile(
            leading: Icon(
              state.showInactiveProducts ? Icons.visibility_off : Icons.visibility,
              color: ProductDesignTokens.primaryColor,
              size: 20,
            ),
            title: Text(
              state.showInactiveProducts ? 'Hide Inactive' : 'Show Inactive',
              style: ProductTheme.getTextStyle(context, 'bodyMedium'),
            ),
            dense: true,
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(ProductDesignTokens.spaceMD),
        decoration: BoxDecoration(
          color: ProductDesignTokens.surfaceSecondary,
          borderRadius: BorderRadius.circular(ProductDesignTokens.radiusMD),
          border: Border.all(color: ProductDesignTokens.borderLight),
        ),
        child: const Icon(
          Icons.more_vert,
          color: ProductDesignTokens.primaryColor,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildBulkActionsBar(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: ProductDesignTokens.spaceMD),
      padding: const EdgeInsets.all(ProductDesignTokens.spaceLG),
      decoration: BoxDecoration(
        color: ProductDesignTokens.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(ProductDesignTokens.radiusLG),
        border: Border.all(
          color: ProductDesignTokens.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          // Selection info
          Row(
            children: [
              Icon(
                Icons.check_circle,
                color: ProductDesignTokens.primaryColor,
                size: 20,
              ),
              const SizedBox(width: ProductDesignTokens.spaceSM),
              Text(
                '${state.selectedProductsCount} product${state.selectedProductsCount == 1 ? '' : 's'} selected',
                style: ProductTheme.getTextStyle(context, 'titleMedium')?.copyWith(
                  color: ProductDesignTokens.primaryColor,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => vm.clearSelection(),
                style: ProductTheme.textButtonTheme,
                child: const Text('Clear Selection'),
              ),
            ],
          ),

          const SizedBox(height: ProductDesignTokens.spaceMD),

          // Bulk actions
          ProductDesignTokens.isMobile(context)
              ? _buildMobileBulkActions(context, state, vm)
              : _buildDesktopBulkActions(context, state, vm),
        ],
      ),
    );
  }

  Widget _buildMobileBulkActions(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => vm.selectAllProducts(),
                icon: const Icon(Icons.select_all, size: 16),
                label: const Text('Select All'),
                style: ProductTheme.secondaryButtonTheme,
              ),
            ),
            const SizedBox(width: ProductDesignTokens.spaceSM),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _exportSelected(context, vm, state),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export'),
                style: ProductTheme.getButtonStyle('success').copyWith(
                  backgroundColor: MaterialStateProperty.all(Colors.transparent),
                  foregroundColor: MaterialStateProperty.all(ProductDesignTokens.successColor),
                  side: MaterialStateProperty.all(
                    const BorderSide(color: ProductDesignTokens.successColor),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: ProductDesignTokens.spaceSM),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: state.isBulkOperating
                ? null
                : () => _confirmBulkDelete(context, vm, state),
            icon: Icon(
              state.isBulkOperating ? Icons.hourglass_empty : Icons.delete,
              size: 16,
            ),
            label: Text(
              state.isBulkOperating ? 'Deleting...' : 'Delete Selected',
            ),
            style: ProductTheme.destructiveButtonTheme,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopBulkActions(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return Row(
      children: [
        // Select All
        OutlinedButton.icon(
          onPressed: () => vm.selectAllProducts(),
          icon: const Icon(Icons.select_all, size: 16),
          label: const Text('Select All'),
          style: ProductTheme.secondaryButtonTheme,
        ),

        const SizedBox(width: ProductDesignTokens.spaceMD),

        // Export Selected
        OutlinedButton.icon(
          onPressed: () => _exportSelected(context, vm, state),
          icon: const Icon(Icons.file_download, size: 16),
          label: const Text('Export Selected'),
          style: ProductTheme.getButtonStyle('success').copyWith(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            foregroundColor: MaterialStateProperty.all(ProductDesignTokens.successColor),
            side: MaterialStateProperty.all(
              const BorderSide(color: ProductDesignTokens.successColor),
            ),
          ),
        ),

        const Spacer(),

        // Delete Selected
        ElevatedButton.icon(
          onPressed: state.isBulkOperating
              ? null
              : () => _confirmBulkDelete(context, vm, state),
          icon: Icon(
            state.isBulkOperating ? Icons.hourglass_empty : Icons.delete,
            size: 16,
          ),
          label: Text(
            state.isBulkOperating ? 'Deleting...' : 'Delete Selected',
          ),
          style: ProductTheme.destructiveButtonTheme,
        ),
      ],
    );
  }

  // Action handlers
  void _navigateToAddProduct(BuildContext context) {
    // TODO: Navigate to add product page using proper routing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Add Product page will be opened'),
        backgroundColor: ProductDesignTokens.successColor,
      ),
    );
  }

  void _showImportDialog(BuildContext context, ProductViewModel vm) {
    // TODO: Show import dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Products from CSV'),
        content: const Text('Import functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ProductTheme.textButtonTheme,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ProductTheme.primaryButtonTheme,
            child: const Text('Import'),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(
    BuildContext context,
    ProductViewModel vm,
    ProductState state,
  ) {
    if (state.hasProducts) {
      vm.exportProductsToCsv(state.products);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Products exported to CSV'),
          backgroundColor: ProductDesignTokens.successColor,
        ),
      );
    }
  }

  void _downloadTemplate(ProductViewModel vm) {
    vm.getCsvTemplate();
  }

  void _handleMoreAction(
    BuildContext context,
    String action,
    ProductViewModel vm,
    ProductState state,
  ) {
    switch (action) {
      case 'refresh':
        vm.fetchAllProducts();
        break;
      case 'select_all':
        vm.selectAllProducts();
        break;
      case 'clear_selection':
        vm.clearSelection();
        break;
      case 'show_inactive':
        vm.toggleShowInactiveProducts();
        break;
    }
  }

  void _exportSelected(
    BuildContext context,
    ProductViewModel vm,
    ProductState state,
  ) {
    final selectedProducts = state.products
        .where((p) => state.selectedProductIds.contains(p.id))
        .toList();

    if (selectedProducts.isNotEmpty) {
      vm.exportProductsToCsv(selectedProducts);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${selectedProducts.length} products exported'),
          backgroundColor: ProductDesignTokens.successColor,
        ),
      );
    }
  }

  void _confirmBulkDelete(
    BuildContext context,
    ProductViewModel vm,
    ProductState state,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Selected Products'),
        content: Text(
          'Are you sure you want to delete ${state.selectedProductsCount} product${state.selectedProductsCount == 1 ? '' : 's'}? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: ProductTheme.textButtonTheme,
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              vm.deleteSelectedProducts();
            },
            style: ProductTheme.destructiveButtonTheme,
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}