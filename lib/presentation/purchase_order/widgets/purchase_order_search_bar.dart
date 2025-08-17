import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/enums/purchase_order_status.dart';
import '../../../di/injection.dart' show purchaseOrderViewModelProvider;

class PurchaseOrderSearchBar extends ConsumerStatefulWidget {
  const PurchaseOrderSearchBar({super.key});

  @override
  ConsumerState<PurchaseOrderSearchBar> createState() =>
      _PurchaseOrderSearchBarState();
}

class _PurchaseOrderSearchBarState
    extends ConsumerState<PurchaseOrderSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    final state = ref.read(purchaseOrderViewModelProvider);
    _searchController.text = state.searchQuery ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(purchaseOrderViewModelProvider);
    final viewModel = ref.read(purchaseOrderViewModelProvider.notifier);

    return Column(
      children: [
        Row(
          children: [
            // Search field
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: viewModel.setSearchQuery,
                decoration: InputDecoration(
                  hintText: "Search by supplier, PO number, or amount...",
                  prefixIcon: const Icon(Icons.search, size: 20),
                  prefixIconConstraints:
                  const BoxConstraints(minWidth: 40),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Filter toggle
            _IconButtonWithBorder(
              icon: Icons.filter_list,
              isActive: _showFilters,
              onPressed: () {
                setState(() {
                  _showFilters = !_showFilters;
                });
              },
            ),

            const SizedBox(width: 8),

            // Sort button (optional)
            _IconButtonWithBorder(
              icon: Icons.sort,
              isActive: false, // Add sorting logic here if needed
              onPressed: () {
                // viewModel.sortBy(...);
              },
            ),
          ],
        ),

        // Filter chips section
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) => SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
          child: _showFilters
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("All"),
                  selected: state.filterStatus == null,
                  onSelected: (_) => viewModel.setFilterStatus(null),
                ),
                ...PurchaseOrderStatus.values.map(
                      (status) => ChoiceChip(
                    label: Text(status.name),
                    selected: state.filterStatus == status,
                    onSelected: (_) =>
                        viewModel.setFilterStatus(status),
                  ),
                ),
              ],
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _IconButtonWithBorder extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const _IconButtonWithBorder({
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isActive ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive
              ? Colors.blueAccent
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: IconButton(
        icon: Icon(icon,
            color: isActive ? Colors.blueAccent : Colors.black54),
        onPressed: onPressed,
      ),
    );
  }
}
