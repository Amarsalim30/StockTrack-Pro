import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends ConsumerStatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  ConsumerState<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends ConsumerState<MainScaffold> {
  late int _selectedIndex;

  final List<String> _routes = [
    '/stock',
    '/stocktake',
    '/suppliers',
    '/settings',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocation = GoRouter.of(context).state.matchedLocation;
    final index = _routes.indexWhere((r) => currentLocation.startsWith(r));
    _selectedIndex = index == -1 ? 0 : index;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    setState(() => _selectedIndex = index);
    context.go(_routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      floatingActionButton: SpeedDial(
        icon: LucideIcons.plus,
        activeIcon: Icons.close,
        animatedIconTheme: IconThemeData(size: 28),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        overlayOpacity: 0.7,
        spacing: 8,
        spaceBetweenChildren: 10,
        tooltip: 'Quick Actions',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: [
          SpeedDialChild(
            child: const Icon(LucideIcons.scan),
            label: 'Scan Barcode',
            onTap: () => context.push('/scan'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          SpeedDialChild(
            child: const Icon(Icons.inventory),
            label: 'New Stock Take',
            onTap: () => context.push('/new-stock-take'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.shopping_cart),
            label: 'New Customer Order',
            onTap: () => context.push('/new-order'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.precision_manufacturing),
            label: 'New Production Run',
            onTap: () => context.push('/new-production'),
          ),
          SpeedDialChild(
            child: const Icon(Icons.group),
            label: 'Team Management',
            onTap: () => context.push('/team-management'),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.inventory,
                label: 'Stock',
                index: 0,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.insert_chart,
                label: 'Stock Take',
                index: 1,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.group,
                label: 'Suppliers',
                index: 2,
                context: context,
              ),
              _buildNavItem(
                icon: Icons.settings,
                label: 'Settings',
                index: 3,
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BuildContext context,
  }) {
    final isSelected = _selectedIndex == index;
    return IconButton(
      icon: Icon(icon),
      tooltip: label,
      color: isSelected ? Theme.of(context).colorScheme.primary : null,
      onPressed: () => _onItemTapped(index),
    );
  }
}
