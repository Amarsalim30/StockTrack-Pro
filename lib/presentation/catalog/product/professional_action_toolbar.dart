import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../di/injection.dart';
import 'product_state.dart';
import 'product_view_model.dart';

class ProfessionalActionToolbar extends ConsumerWidget {
  const ProfessionalActionToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productViewModelProvider);
    final vm = ref.read(productViewModelProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Main action bar
          _buildMainActionBar(context, state, vm),

          // Bulk actions bar (shown when products are selected)
          if (state.hasSelectedProducts)
            _buildBulkActionsBar(context, state, vm),
        ],
      ),
    );
  }

  Widget _buildMainActionBar(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                // Primary actions first on mobile
                _buildPrimaryActions(context, state, vm),

                const SizedBox(height: 12),

                // Divider
                Container(
                  height: 1,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                ),

                // Import/Export actions below on mobile
                _buildImportExportActions(context, state, vm),
              ],
            )
          : Row(
              children: [
                // Left side - Import/Export actions
                Expanded(
                  child: _buildImportExportActions(context, state, vm),
                ),

                // Divider
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                ),

                // Right side - Primary actions
                _buildPrimaryActions(context, state, vm),
              ],
            ),
    );
  }

  Widget _buildImportExportActions(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  label: 'Import CSV',
                  icon: Icons.file_upload_outlined,
                  color: Colors.blue,
                  isLoading: state.isImporting,
                  onPressed: () => _showImportDialog(context, vm),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  label: 'Export CSV',
                  icon: Icons.file_download_outlined,
                  color: Colors.green,
                  isLoading: state.isExporting,
                  isEnabled: state.hasProducts,
                  onPressed: () => _showExportDialog(context, vm, state),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildActionButton(
            label: 'Download Template',
            icon: Icons.description_outlined,
            color: Colors.orange,
            isLoading: state.isValidating,
            onPressed: () => _downloadTemplate(vm),
          ),
        ],
      );
    }

    return Row(
      children: [
        // Import CSV button
        _buildActionButton(
          label: 'Import CSV',
          icon: Icons.file_upload_outlined,
          color: Colors.blue,
          isLoading: state.isImporting,
          onPressed: () => _showImportDialog(context, vm),
        ),

        const SizedBox(width: 12),

        // Export CSV button
        _buildActionButton(
          label: 'Export CSV',
          icon: Icons.file_download_outlined,
          color: Colors.green,
          isLoading: state.isExporting,
          isEnabled: state.hasProducts,
          onPressed: () => _showExportDialog(context, vm, state),
        ),

        const SizedBox(width: 12),

        // Template button
        _buildActionButton(
          label: 'Template',
          icon: Icons.description_outlined,
          color: Colors.orange,
          isLoading: state.isValidating,
          onPressed: () => _downloadTemplate(vm),
          isCompact: true,
        ),
      ],
    );
  }

  Widget _buildPrimaryActions(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    if (isMobile) {
      return Row(
        children: [
          Expanded(
            child: _buildPrimaryActionButton(
              label: 'Add Product',
              icon: Icons.add_circle_outline,
              onPressed: () => _navigateToAddProduct(context),
            ),
          ),
          const SizedBox(width: 12),
          _buildMoreActionsMenu(context, state, vm),
        ],
      );
    }

    return Row(
      children: [
        // Add Product button
        _buildPrimaryActionButton(
          label: 'Add Product',
          icon: Icons.add_circle_outline,
          onPressed: () => _navigateToAddProduct(context),
        ),

        const SizedBox(width: 12),

        // More actions menu
        _buildMoreActionsMenu(context, state, vm),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    bool isCompact = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: OutlinedButton.icon(
        onPressed: isEnabled && !isLoading ? onPressed : null,
        icon: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                )
              : Icon(icon, size: 18),
        ),
        label: isCompact ? const SizedBox.shrink() : Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: isEnabled ? color : Colors.grey,
          side: BorderSide(
            color: isEnabled ? color.withOpacity(0.3) : Colors.grey.shade300,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 12 : 16,
            vertical: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0E2330),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  Widget _buildMoreActionsMenu(
    BuildContext context,
    ProductState state,
    ProductViewModel vm,
  ) {
    return PopupMenuButton<String>(
      onSelected: (value) => _handleMoreAction(context, value, vm, state),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'refresh',
          child: ListTile(
            leading: Icon(Icons.refresh),
            title: Text('Refresh'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'select_all',
          child: ListTile(
            leading: Icon(Icons.select_all),
            title: Text('Select All'),
            dense: true,
          ),
        ),
        const PopupMenuItem(
          value: 'clear_selection',
          child: ListTile(
            leading: Icon(Icons.clear),
            title: Text('Clear Selection'),
            dense: true,
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'show_inactive',
          child: ListTile(
            leading: Icon(Icons.visibility_off),
            title: Text('Toggle Inactive'),
            dense: true,
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.more_vert,
          color: Color(0xFF0E2330),
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0E2330).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0E2330).withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Selection info
          Icon(
            Icons.check_circle,
            color: const Color(0xFF0E2330),
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${state.selectedProductsCount} products selected',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E2330),
            ),
          ),

          const Spacer(),

          // Bulk actions
          Row(
            children: [
              // Select All
              TextButton.icon(
                onPressed: () => vm.selectAllProducts(),
                icon: const Icon(Icons.select_all, size: 16),
                label: const Text('All'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0E2330),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),

              // Clear Selection
              TextButton.icon(
                onPressed: () => vm.clearSelection(),
                icon: const Icon(Icons.clear, size: 16),
                label: const Text('Clear'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey.shade600,
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),

              // Export Selected
              OutlinedButton.icon(
                onPressed: () => _exportSelected(context, vm, state),
                icon: const Icon(Icons.file_download, size: 16),
                label: const Text('Export'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: const TextStyle(fontSize: 12),
                ),
              ),

              const SizedBox(width: 8),

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
                  state.isBulkOperating ? 'Deleting...' : 'Delete',
                  style: const TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showImportDialog(BuildContext context, ProductViewModel vm) {
    // TODO: Implement import dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Import Products from CSV'),
        content: const Text('Import functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
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
        const SnackBar(
          content: Text('Products exported to CSV'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _downloadTemplate(ProductViewModel vm) {
    vm.getCsvTemplate();
  }

  void _navigateToAddProduct(BuildContext context) {
    // TODO: Navigate to add product page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add Product page will be opened'),
      ),
    );
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
          backgroundColor: Colors.green,
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
          'Are you sure you want to delete ${state.selectedProductsCount} products? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              vm.deleteSelectedProducts();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}