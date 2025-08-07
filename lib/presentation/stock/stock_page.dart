// lib/presentation/stock/stock_page.dart

import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:clean_arch_app/presentation/stocktake/stocktake_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/colors.dart';
import '../../core/enums/stock_status.dart';
import '../../di/injection.dart' as di;
import '../dashboard/dashboard_view_model.dart';
import 'widgets/advanced_stock_list.dart';

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final stockViewModel = ref.read(di.stockViewModelProvider.notifier);
    stockViewModel.setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stockState = ref.watch(di.stockViewModelProvider);
    final stockViewModel = ref.watch(di.stockViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, ref, stockState),
          _buildSliverBody(context, ref, stockState, stockViewModel),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(context, ref),
    );
  }

  Widget _buildInventoryHeader(DashboardViewModel vm, StockViewModel stockVm ,stockState) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Search Field (consistent black/grey style, no shadow)
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              textAlign: TextAlign.start,
              onChanged: stockVm.setSearchQuery,
              style: const TextStyle(fontSize: 15, color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search inventory...',
                hintStyle: TextStyle(color: Colors.grey[700]),
                prefixIcon: const Icon(
                  Icons.search, color: Colors.grey, size: 20,),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 0,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Colors.black,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8,),
        SizedBox(
          height: 40,
          child: PopupMenuButton<String>(
            onSelected: (value) {
              // handle the selected filter value
              vm.setFilter(value);
            },
            itemBuilder: (context) =>
            [
              PopupMenuItem(value: 'All', child: Text('All')),
              PopupMenuItem(value: 'Available', child: Text('Available')),
              PopupMenuItem(value: 'Out of Stock', child: Text('Out of Stock')),
            ],
            offset: Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey.shade300),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    LucideIcons.filter,
                    size: 18,
                    color: Colors.black87,
                  ),
                  SizedBox(width: 6),
                  Icon(
                    LucideIcons.chevron_down,
                    size: 18,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 6,),

        PopupMenuButton<SortBy>(
          onSelected: (SortBy selected) {
            final isSame = selected == stockState.sortBy;
            stockVm.setSortBy(selected);
            if (isSame) {
              stockVm.toggleSortOrder(
                  selected); // If same item tapped again, toggle order
            }
          },
          itemBuilder: (context) =>
              SortBy.values.map((sortBy) {
                return PopupMenuItem(
                  value: sortBy,
                  child: Row(
                    children: [
                      Text(sortBy.name.toString()),
                      const Spacer(),
                      if (stockState.sortBy == sortBy)
                        Icon(
                          stockState.sortOrder == SortOrder.ascending
                              ? LucideIcons.arrow_up
                              : LucideIcons.arrow_down,
                          size: 16,
                        ),
                    ],
                  ),
                );
              }).toList(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  stockState.sortOrder == SortOrder.ascending
                      ? LucideIcons.arrow_up
                      : LucideIcons.arrow_down,
                  size: 18,
                  color: Colors.black87,
                ),
                const SizedBox(width: 6),
                Text(stockState.sortBy.toString()),
                const SizedBox(width: 6),
                const Icon(
                  LucideIcons.chevron_down,
                  size: 18,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}


