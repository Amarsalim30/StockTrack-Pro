import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';

class MainScaffold extends StatefulWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  final ValueNotifier<bool> _dialOpen = ValueNotifier(false);
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.inventory_outlined, label: 'Stock', route: '/stock'),
    _NavItem(icon: Icons.add_business_outlined, label: 'Purchase Order', route: '/purchase-orders'),
    _NavItem(icon: Icons.bar_chart_sharp, label: 'Reporting', route: '/stats'),
    _NavItem(icon: Icons.history_outlined, label: 'Activity', route: '/profile'),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    GoRouter.of(context).go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      floatingActionButton: _buildFab(theme, 56),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 60,
          color: const Color(0xFF0E2330),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final selected = i == _selectedIndex;
              return InkWell(
                onTap: () => _onItemTapped(i),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      item.icon,
                      size: selected ? 26 : 24,
                      color: selected ? Colors.cyanAccent : Colors.white,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected ? Colors.cyanAccent : Colors.white70,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(ThemeData theme, double diameter) {
    final actions = <_ActionItem>[
      _ActionItem(icon: LucideIcons.scan, label: 'Scan Barcode', route: '/scan'),
      _ActionItem(icon: Icons.inventory_2_outlined, label: 'New Stock Take', route: '/new-stock-take'),
      _ActionItem(icon: Icons.precision_manufacturing, label: 'New Production', route: '/new-production'),
      _ActionItem(icon: Icons.article_outlined, label: 'New BOM', route: '/new-bom'),
      _ActionItem(icon: Icons.shopping_cart_outlined, label: 'New Order', route: '/new-order'),
    ];

    return SpeedDial(
      icon: null, // We handle our own icon animation
      openCloseDial: _dialOpen,
      overlayOpacity: 0.5,
      overlayColor: Colors.black,
      backgroundColor: Colors.transparent,
      elevation: 1,
      spacing: 5,
      spaceBetweenChildren: 5,
      children: actions
          .map((action) => SpeedDialChild(
        backgroundColor: const Color(0xFF0E2330),
        child: Icon(action.icon, color: Colors.white, size: 18), // smaller icon
        label: action.label,
        labelStyle: const TextStyle(color: Colors.white, fontSize: 13),
        labelBackgroundColor: Colors.transparent,
        onTap: () => GoRouter.of(context).push(action.route),
      ))
          .toList(),
      child: ValueListenableBuilder<bool>(
        valueListenable: _dialOpen,
        builder: (context, isOpen, _) {
          return AnimatedRotation(
            duration: const Duration(milliseconds: 250),
            turns: isOpen ? 0.125 : 0, // 45° rotation
            child: Container(
              width: diameter,
              height: diameter,
              decoration: const BoxDecoration(
                color: Color(0xFF0E2330),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  _NavItem({required this.icon, required this.label, required this.route});
}

class _ActionItem {
  final IconData icon;
  final String label;
  final String route;
  _ActionItem({required this.icon, required this.label, required this.route});
}
