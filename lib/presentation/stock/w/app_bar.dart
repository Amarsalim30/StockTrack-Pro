
import 'package:clean_arch_app/core/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucide/flutter_lucide.dart';

AppBar buildAppBar(BuildContext context, dynamic stockState) {
  // Determine if we have a selection
  final selectedCount = stockState?.selectedStockIds?.length ?? 0;
  final hasSelection = selectedCount > 0;
  final backgroundColor = hasSelection
      ? AppColors.slate[900]
      : AppColors.slate[700];


  return AppBar(
    backgroundColor: backgroundColor,
    elevation: hasSelection ? 4 : 0,
    titleSpacing: 16.0,
    title: AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: hasSelection
          ? Row(
        key: const ValueKey('selection'),
        children: [
          Icon(LucideIcons.square_check, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Text(
            '$selectedCount selected',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      )
          : Column(
        key: const ValueKey('title'),
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'StockTrackPro',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Professional Inventory Management',
            style: TextStyle(fontSize: 11, color: Colors.white70),
          ),
        ],
      ),
    ),
    centerTitle: false,
    leading: hasSelection
        ? IconButton(
      icon: const Icon(LucideIcons.x, color: Colors.white),
      onPressed: () {
        // Clear selection
        HapticFeedback.selectionClick();
      },
    )
        : null,
    actions: hasSelection
        ? _buildSelectionActions(context, selectedCount)
        : _buildNormalActions(context),
  );
}

List<Widget> _buildSelectionActions(BuildContext context, int count) {
  return [
    IconButton(
      tooltip: 'Export selected',
      onPressed: () {
        HapticFeedback.selectionClick();
        // Handle export
      },
      icon: const Icon(LucideIcons.download, color: Colors.white),
    ),
    IconButton(
      tooltip: 'Delete selected',
      onPressed: () {
        HapticFeedback.mediumImpact();
        _showBulkDeleteConfirmation(context, count);
      },
      icon: const Icon(LucideIcons.trash_2, color: Colors.white),
    ),
    const SizedBox(width: 8),
  ];
}

List<Widget> _buildNormalActions(BuildContext context) {
  return [
    IconButton(
      tooltip: 'Search',
      onPressed: () {
        // Show search overlay or focus search field
      },
      icon: const Icon(LucideIcons.search, color: Colors.white, size: 20),
    ),
    PopupMenuButton<String>(
      tooltip: 'More options',
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (value) {
        switch (value) {
          case 'import':
          // Handle import
            break;
          case 'export_all':
          // Handle export all
            break;
          case 'settings':
          // Handle settings
            break;
        }
      },
      itemBuilder: (context) =>
      [
        const PopupMenuItem(
          value: 'import',
          child: Row(
            children: [
              Icon(LucideIcons.upload, size: 16),
              SizedBox(width: 8),
              Text('Import Stock'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'export_all',
          child: Row(
            children: [
              Icon(LucideIcons.download, size: 16),
              SizedBox(width: 8),
              Text('Export All'),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(LucideIcons.settings, size: 16),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
      ],
    ),
    const SizedBox(width: 8),
  ];
}
void _showBulkDeleteConfirmation(BuildContext context, int count) {
  showDialog(
    context: context,
    builder: (ctx) =>
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          title: Text('Delete $count Items'),
          content: Text(
            'Are you sure you want to delete $count selected item${count == 1
                ? ''
                : 's'}? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                // Handle bulk delete
                HapticFeedback.mediumImpact();
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

