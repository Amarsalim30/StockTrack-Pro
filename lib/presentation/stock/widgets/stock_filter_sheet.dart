import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stock_state.dart';
import '../stock_view_model.dart';
import '../../../core/enums/stock_status.dart';

class StockFilterSheet extends StatelessWidget {
  const StockFilterSheet({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<StockViewModel>(context);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            'Filter & Sort',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),

          // Status Filter Section
          Text(
            'Filter by Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              FilterChip(
                label: Text('All'),
                selected: viewModel.filterStatus == null,
                onSelected: (_) {
                  viewModel.setFilterStatus(null);
                  Navigator.pop(context);
                },
              ),
              ...StockStatus.values.map(
                (status) => FilterChip(
                  label: Text(_getStatusDisplayText(status)),
                  selected: viewModel.filterStatus == status,
                  onSelected: (_) {
                    viewModel.setFilterStatus(status);
                    Navigator.pop(context);
                  },
                  backgroundColor: _getStatusColor(status).withOpacity(0.2),
                  selectedColor: _getStatusColor(status).withOpacity(0.4),
                ),
              ),
            ],
          ),

          SizedBox(height: 24),

          // Sort Section
          Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12),

          // Sort options
          _buildSortOption(
            context,
            'Name',
            SortBy.name,
            viewModel.sortBy == SortBy.name,
            viewModel.sortOrder,
            () {
              viewModel.setSortBy(SortBy.name);
              Navigator.pop(context);
            },
          ),
          _buildSortOption(
            context,
            'SKU',
            SortBy.sku,
            viewModel.sortBy == SortBy.sku,
            viewModel.sortOrder,
            () {
              viewModel.setSortBy(SortBy.sku);
              Navigator.pop(context);
            },
          ),
          _buildSortOption(
            context,
            'Quantity',
            SortBy.quantity,
            viewModel.sortBy == SortBy.quantity,
            viewModel.sortOrder,
            () {
              viewModel.setSortBy(SortBy.quantity);
              Navigator.pop(context);
            },
          ),
          _buildSortOption(
            context,
            'Last Updated',
            SortBy.lastUpdated,
            viewModel.sortBy == SortBy.lastUpdated,
            viewModel.sortOrder,
            () {
              viewModel.setSortBy(SortBy.lastUpdated);
              Navigator.pop(context);
            },
          ),

          SizedBox(height: 24),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    viewModel.setFilterStatus(null);
                    viewModel.setSortBy(SortBy.name);
                    Navigator.pop(context);
                  },
                  child: Text('Reset'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Apply'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String label,
    SortBy sortBy,
    bool isSelected,
    SortOrder currentOrder,
    VoidCallback onTap,
  ) {
    return ListTile(
      title: Text(label),
      trailing: isSelected
          ? Icon(
              currentOrder == SortOrder.ascending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Theme.of(context).primaryColor,
            )
          : null,
      selected: isSelected,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String _getStatusDisplayText(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return 'In Stock';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.discontinued:
        return 'Discontinued';
      case StockStatus.available:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.reserved:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.damaged:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.expired:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.inTransit:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  Color _getStatusColor(StockStatus status) {
    switch (status) {
      case StockStatus.inStock:
        return Colors.green;
      case StockStatus.lowStock:
        return Colors.orange;
      case StockStatus.outOfStock:
        return Colors.red;
      case StockStatus.discontinued:
        return Colors.grey;
      case StockStatus.available:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.reserved:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.damaged:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.expired:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.inTransit:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }
}
