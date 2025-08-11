import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../di/injection.dart' as di;

class SearchControlBar extends ConsumerWidget {
  const SearchControlBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockVM = ref.read(di.stockViewModelProvider.notifier);
    final searchQuery = ref.watch(di.stockViewModelProvider.select((s) => s.searchQuery ?? ''));

    final controller = TextEditingController(text: searchQuery)
      ..selection = TextSelection.fromPosition(TextPosition(offset: searchQuery.length));

    return Row(
      children: [
        // Search Field
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: stockVM.setSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search inventory...',
              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF9CA3AF)),
              prefixIcon: const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
              suffixIcon: searchQuery.isNotEmpty
                  ? GestureDetector(
                onTap: () => stockVM.setSearchQuery(''),
                child: const Icon(Icons.close, size: 18, color: Color(0xFF9CA3AF)),
              )
                  : null,
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // Filter button
        IconButton(
          onPressed: () {
            // Could open bottom sheet or menu for status filter
            stockVM.setFilterStatus(StockStatus.available);
          },
          icon: const Icon(Icons.filter_list, size: 22, color: Color(0xFF4B5563)),
          splashRadius: 22,
        ),

        // Sort button
        IconButton(
          onPressed: () {
            // Could toggle sort order or open menu
            stockVM.setSortBy(SortBy.name); // Replace with actual logic
          },
          icon: const Icon(Icons.swap_vert, size: 22, color: Color(0xFF4B5563)),
          splashRadius: 22,
        ),
      ],
    );
  }
}
