// search_control_bar_fixed.dart
import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/presentation/stock/stock_state.dart';
import 'package:clean_arch_app/presentation/stock/stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool showFilters = false;
  late final TextEditingController _searchController;

  late final AnimationController _panelController; // slide+fade container
  late final AnimationController _chipController; // staggered chips

  static const _chipStagger = 0.08;

  // Fixed FocusNodes for chips to avoid reparenting issues
  late final List<FocusNode> _chipFocusNodes;

  // Chip definitions (kept here so count is stable)
  final List<Map<String, Object?>> _chips = [
    {'label': 'All', 'status': null},
    {'label': 'In Stock', 'status': StockStatus.inStock},
    {'label': 'Low Stock', 'status': StockStatus.lowStock},
    {'label': 'Out of Stock', 'status': StockStatus.outOfStock},
  ];

  @override
  void initState() {
    super.initState();

    // init text controller with current state query
    final initialQuery = ref.read(di.stockViewModelProvider).searchQuery ?? '';
    _searchController = TextEditingController(text: initialQuery)
      ..selection = TextSelection.fromPosition(TextPosition(offset: initialQuery.length));

    // animation controllers
    _panelController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _chipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );

    // create stable focus nodes (one per chip)
    _chipFocusNodes = List.generate(_chips.length, (_) => FocusNode(debugLabel: 'chip'));

    // keep text field in sync with state safely
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
    _panelController.dispose();
    _chipController.dispose();
    _searchController.dispose();
    for (final n in _chipFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _openFilters() {
    if (!mounted) return;
    setState(() => showFilters = true);
    _panelController.forward();
    // small delay so panel exists before chips animate
    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) _chipController.forward();
    });
    // focus first chip slightly later
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted && _chipFocusNodes.isNotEmpty) _chipFocusNodes.first.requestFocus();
    });
  }

  void _closeFilters() {
    if (!mounted) return;
    _chipController.reverse();
    _panelController.reverse().then((_) {
      if (mounted) setState(() => showFilters = false);
    });
  }

  void _toggleFilters() {
    if (showFilters) _closeFilters();
    else _openFilters();
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.read(di.stockViewModelProvider.notifier);
    final state = ref.watch(di.stockViewModelProvider);
    final bool filterActive = state.filterStatus != null;
    final bool sortActive = state.sortBy != null;

    // panel slide/fade animation
    final panelSlide = Tween<Offset>(begin: const Offset(0, -0.02), end: Offset.zero)
        .animate(CurvedAnimation(parent: _panelController, curve: Curves.easeOut));
    final panelFade = CurvedAnimation(parent: _panelController, curve: Curves.easeOut);

    return Column(
      children: [
        Row(
          children: [
            // Search input
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
                    fillColor: const Color(0xFFF7F8FA),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Filter toggle
            _IconCircleButton(
              icon: Icons.filter_list,
              active: filterActive || showFilters,
              onPressed: _toggleFilters,
            ),
            const SizedBox(width: 8),

            // Sort popup
            _IconCircleButton(
              icon: Icons.sort,
              active: sortActive,
              onPressed: () => _showSortMenu(context, vm),
            ),
          ],
        ),

        // Animated panel (slide + fade + AnimatedSize for smooth height change)
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: showFilters
              ? SlideTransition(
            position: panelSlide,
            child: FadeTransition(
              opacity: panelFade,
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE6E9EE)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_chips.length, (i) {
                        final label = _chips[i]['label'] as String;
                        final target = _chips[i]['status'] as StockStatus?;
                        return _buildAnimatedChip(
                          index: i,
                          label: label,
                          target: target,
                          vm: vm,
                          state: state,
                          focusNode: _chipFocusNodes[i],
                          onLeft: () {
                            if (i - 1 >= 0) _chipFocusNodes[i - 1].requestFocus();
                          },
                          onRight: () {
                            if (i + 1 < _chipFocusNodes.length) _chipFocusNodes[i + 1].requestFocus();
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => vm.setFilterStatus(null),
                          child: const Text('Clear filters'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _closeFilters,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Done'),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildAnimatedChip({
    required int index,
    required String label,
    required StockStatus? target,
    required StockViewModel vm,
    required StockState state,
    required FocusNode focusNode,
    required VoidCallback onLeft,
    required VoidCallback onRight,
  }) {
    final start = (index * _chipStagger).clamp(0.0, 0.9);
    final end = (start + 0.5).clamp(0.0, 1.0);

    final curved = CurvedAnimation(
      parent: _chipController,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
      reverseCurve: Interval(start, end, curve: Curves.easeInCubic),
    );

    final isSelected = state.filterStatus == target || (state.filterStatus == null && target == null);

    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(curved),
        child: Focus(
          focusNode: focusNode,
          onKey: (node, event) {
            if (event is RawKeyDownEvent) {
              final key = event.logicalKey;
              if (key == LogicalKeyboardKey.arrowLeft) {
                onLeft();
                return KeyEventResult.handled;
              } else if (key == LogicalKeyboardKey.arrowRight) {
                onRight();
                return KeyEventResult.handled;
              } else if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.space) {
                vm.setFilterStatus(target);
                return KeyEventResult.handled;
              } else if (key == LogicalKeyboardKey.escape) {
                _closeFilters();
                return KeyEventResult.handled;
              }
            }
            return KeyEventResult.ignored;
          },
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => vm.setFilterStatus(target),
            child: ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => vm.setFilterStatus(target),
              selectedColor: Colors.blue.shade50,
              backgroundColor: Colors.grey.shade50,
              labelStyle: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.grey.shade800,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context, StockViewModel vm) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        overlay.size.width - 120,
        kToolbarHeight + 12,
        16,
        0,
      ),
      items: [
        PopupMenuItem(
          child: const Text("Name (A–Z)"),
          onTap: () => vm.setSortBy(SortBy.nameAsc),
        ),
        PopupMenuItem(
          child: const Text("Name (Z–A)"),
          onTap: () => vm.setSortBy(SortBy.nameDesc),
        ),
        PopupMenuItem(
          child: const Text("Quantity (Low → High)"),
          onTap: () => vm.setSortBy(SortBy.quantityAsc),
        ),
        PopupMenuItem(
          child: const Text("Quantity (High → Low)"),
          onTap: () => vm.setSortBy(SortBy.quantityDesc),
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
