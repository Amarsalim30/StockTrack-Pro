// search_control_bar_fixed.dart
import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../di/injection.dart' as di;

class SearchControlBar extends ConsumerStatefulWidget {
  final String hintText;
  const SearchControlBar({super.key, this.hintText = 'Search stocks...'});

  @override
  ConsumerState<SearchControlBar> createState() => _SearchControlBarState();
}

class _SearchControlBarState extends ConsumerState<SearchControlBar>
    with TickerProviderStateMixin {
  late final TextEditingController _searchController;

  final List<Map<String, Object?>> _chips = [
    {'label': 'All', 'status': null},
    {'label': 'In Stock', 'status': StockStatus.inStock},
    {'label': 'Low Stock', 'status': StockStatus.lowStock},
    {'label': 'Out of Stock', 'status': StockStatus.outOfStock},
  ];

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(di.stockViewModelProvider).searchQuery ?? '';
    _searchController = TextEditingController(text: initialQuery)
      ..selection = TextSelection.fromPosition(TextPosition(offset: initialQuery.length));

    ref.listenManual<StockState>(di.stockViewModelProvider, (previous, next) {
      final nextQuery = next.searchQuery ?? '';
      if (_searchController.text != nextQuery && mounted) {
        _searchController.text = nextQuery;
        _searchController.selection = TextSelection.fromPosition(
          TextPosition(offset: _searchController.text.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openRefineSheet(StockViewModel vm, StockState state) {
    StockStatus? tempFilter = state.filterStatus;
    SortBy? tempSort = state.sortBy;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: StatefulBuilder(
              builder: (context, setModalState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Filters',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _chips.asMap().entries.map((entry) {
                          final i = entry.key;
                          final chip = entry.value;
                          final label = chip['label'] as String;
                          final target = chip['status'] as StockStatus?;
                          final selected = tempFilter == target || (tempFilter == null && target == null);
                          return AnimatedOpacity(
                            opacity: 1,
                            duration: Duration(milliseconds: 100 + i * 60),
                            child: ChoiceChip(
                              label: Text(label),
                              selected: selected,
                              onSelected: (_) => setModalState(() => tempFilter = target),
                              selectedColor: Colors.blue.shade50,
                              backgroundColor: Colors.grey.shade50,
                              labelStyle: TextStyle(
                                color: selected ? Colors.blue.shade700 : Colors.grey.shade800,
                                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setModalState(() => tempFilter = null),
                        child: const Text('Clear filters'),
                      ),
                    ),
                // In the _openRefineSheet method — updated sort section with slide animation

                const Divider(height: 24),
                const Text('Sort By',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: AnimatedSlide(
                offset: const Offset(0, 0.1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: Column(
                children: [
                RadioListTile<SortBy>(
                title: const Text("Name (A–Z)"),
                value: SortBy.nameAsc,
                groupValue: tempSort,
                onChanged: (v) => setModalState(() => tempSort = v),
                ),
                RadioListTile<SortBy>(
                title: const Text("Name (Z–A)"),
                value: SortBy.nameDesc,
                groupValue: tempSort,
                onChanged: (v) => setModalState(() => tempSort = v),
                ),
                RadioListTile<SortBy>(
                title: const Text("Quantity (Low → High)"),
                value: SortBy.quantityAsc,
                groupValue: tempSort,
                onChanged: (v) => setModalState(() => tempSort = v),
                ),
                RadioListTile<SortBy>(
                title: const Text("Quantity (High → Low)"),
                value: SortBy.quantityDesc,
                groupValue: tempSort,
                onChanged: (v) => setModalState(() => tempSort = v),
                ),
                ],
                ),
                ),
                ),
                    const Divider(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              vm.setFilterStatus(tempFilter);
                              vm.setSortBy(SortBy.values.firstWhere((e) => e == tempSort));
                              Navigator.pop(context);
                            },
                            child: const Text('Apply'),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(di.stockViewModelProvider.notifier);
    final state = ref.watch(di.stockViewModelProvider);

    final bool hasActiveFilter = state.filterStatus != null;
    final bool hasActiveSort = state.sortBy != null;

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: vm.setSearchQuery,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: widget.hintText,
                prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF9AA6B2)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
              ),
            ),
          ),
        ),
        SizedBox(
        height: 40,
        child: TextButton(
        style: TextButton.styleFrom(
        backgroundColor: Colors.transparent, // No fill
        foregroundColor: Colors.blue.withOpacity(0.9), // Slight transparency
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: Size.zero,
        ),
        onPressed: vm.toggleBulkSelectionMode,
        child: Text(
        state.isBulkSelectionMode ? "Cancel" : "Select",
        style: TextStyle(
        fontWeight: state.isBulkSelectionMode ? FontWeight.w600 : FontWeight.w400,
    fontSize: 14,
    ),
    ),
    ),
    ),

        const SizedBox(width: 8),
        _IconCircleButton(
          icon: Icons.tune,
          active: hasActiveFilter || hasActiveSort,
          onPressed: () => _openRefineSheet(vm, state),
        ),
      ],
    );
  }
}

class _IconCircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool active;
  const _IconCircleButton({required this.icon, required this.onPressed, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: ShapeDecoration(
        color: active ? Colors.blue.shade50 : const Color(0xFFF7F8FA),
        shape: const CircleBorder(),
      ),
      child: IconButton(
        icon: Icon(icon, color: active ? Colors.blue.shade700 : Colors.grey.shade700, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
