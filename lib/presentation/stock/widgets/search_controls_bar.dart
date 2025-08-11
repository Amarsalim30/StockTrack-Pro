import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchControlBar extends StatelessWidget {
  final String hintText;

  const SearchControlBar({Key? key, this.hintText = 'Search stocks...'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = context.read<StockViewModel>();

    // Shared decoration for dropdowns & search
    InputDecoration _inputDecoration(String label) {
      return InputDecoration(
        labelText: label,
        filled: true,
        fillColor: const Color(0xFFF7F8FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      );
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          // Search field
          Expanded(
            flex: 3,
            child: TextField(
              onChanged: vm.setSearchQuery,
              decoration: _inputDecoration(hintText).copyWith(
                prefixIcon: const Icon(Icons.search, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Sort dropdown
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              value: 'name',
              decoration: _inputDecoration('Sort by'),
              items: const [
                DropdownMenuItem(value: 'name', child: Text('Name')),
                DropdownMenuItem(value: 'quantity', child: Text('Quantity')),
              ],
              onChanged: (value) {
                if (value != null) vm.setSortBy(SortBy.fromString(value));
              },
              icon: const Icon(Icons.arrow_drop_down, size: 20),
            ),
          ),
          const SizedBox(width: 12),

          // Status filter dropdown
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<String>(
              value: 'all',
              decoration: _inputDecoration('Status'),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All')),
                DropdownMenuItem(value: 'in-stock', child: Text('In Stock')),
                DropdownMenuItem(value: 'low-stock', child: Text('Low Stock')),
                DropdownMenuItem(value: 'out-of-stock', child: Text('Out of Stock')),
              ],
              onChanged: (value) {
                if (value != null) vm.setFilterStatus(StockStatus.fromString(value));
              },
              icon: const Icon(Icons.arrow_drop_down, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
