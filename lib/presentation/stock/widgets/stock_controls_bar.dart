import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import '../stock_state.dart';

class ControlsBar extends StatelessWidget {
  final bool narrow;
  final void Function(String) onSearch;
  final VoidCallback onClearSearch;
  final void Function(String) onFilterSelected;
  final void Function(dynamic) onSortSelected;

  final String searchQuery;
  final bool isBulkMode;
  final String? currentFilter;
  final dynamic currentSortBy;
  final SortOrder currentSortOrder;
  final List<SortBy> sortOptions;
  final VoidCallback onOpenAdvancedFilter;

  const ControlsBar({
    super.key,
    required this.narrow,
    required this.onSearch,
    required this.onClearSearch,
    required this.onFilterSelected,
    required this.onSortSelected,
    required this.searchQuery,
    required this.isBulkMode,
    required this.currentFilter,
    required this.currentSortBy,
    required this.currentSortOrder,
    required this.sortOptions ,
    required this.onOpenAdvancedFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8,
      spacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildSearchField(context),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterButton(context),
            const SizedBox(width: 8),
            _buildSortButton(context),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: narrow
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width * 0.62,
        minWidth: 180,
      ),
      child: SizedBox(
        height: 44,
        child: TextField(
          onChanged: onSearch,
          controller: TextEditingController(text: searchQuery),
          textAlignVertical: TextAlignVertical.center,
          style: const TextStyle(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: 'Search inventory...',
            hintStyle: TextStyle(color: Colors.grey[700]),
            prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
            suffixIcon: searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClearSearch,
              tooltip: 'Clear search',
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding:
            const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black, width: 1.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: PopupMenuButton<String>(
        tooltip: 'Filter items',
        onSelected: onFilterSelected,
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'All', child: Text('All')),
          PopupMenuItem(value: 'Available', child: Text('Available')),
          PopupMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
        ],
        offset: const Offset(0, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: _buildButtonContainer(
          icon: LucideIcons.filter,
          label: currentFilter ?? 'Filter',
        ),
      ),
    );
  }

  Widget _buildSortButton(BuildContext context) {
    return SizedBox(
      height: 44,
      child: PopupMenuButton<dynamic>(
        tooltip: 'Sort items',
        onSelected: onSortSelected,
        itemBuilder: (_) {
          return sortOptions.map((s) {
            return PopupMenuItem(
              value: s,child: Row(
                children: [
                  Text(s.label),
                  const Spacer(),
                  if (currentSortBy == s)
                    Icon(
                      currentSortOrder == SortOrder.ascending
                          ? LucideIcons.arrow_up
                          : LucideIcons.arrow_down,
                      size: 16,
                    ),
                ],
              ),
            );
          }).toList();
        },
        offset: const Offset(0, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade300),
        ),child: _buildButtonContainer(
          icon: currentSortOrder == SortOrder.ascending
              ? LucideIcons.arrow_up
              : LucideIcons.arrow_down,
          label: (currentSortBy as SortBy?)?.label ?? 'Sort',
        ),
      ),
    );
  }

  Widget _buildButtonContainer({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black87),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.black87)),
          const SizedBox(width: 6),
          const Icon(LucideIcons.chevron_down,
              size: 18, color: Colors.black54),
        ],
      ),
    );
  }
}
