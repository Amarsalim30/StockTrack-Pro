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
    _NavItem(icon: Icons.inventory_outlined, label: 'Stock', route: '/'),
    _NavItem(icon: Icons.cameraswitch_rounded, label: 'Purchase Order', route: '/health'),
    _NavItem(icon: Icons.bar_chart_sharp, label: 'Reporting', route: '/stats'),
    _NavItem(icon: Icons.history_outlined, label: 'activity', route: '/profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    GoRouter.of(context).go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: widget.child,
      floatingActionButton: _buildFab(theme, 56, 28),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                        fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                        color:
                        selected ? Colors.cyanAccent : Colors.white70,
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

  Widget _buildFab(ThemeData theme, double diameter, double iconSize) {
    final actions = <_ActionItem>[
      _ActionItem(icon: LucideIcons.activity, label: 'Add blood pressure', route: '/bp'),
      _ActionItem(icon: LucideIcons.weight, label: 'Add weight', route: '/weight'),
      _ActionItem(icon: LucideIcons.pencil, label: 'Add activity', route: '/activity'),
      _ActionItem(icon: Icons.run_circle_outlined, label: 'Track workout', route: '/workout'),
    ];

    return SpeedDial(
      icon: null,
      child: AnimatedRotation(
        duration: const Duration(milliseconds: 250),
        turns: _dialOpen.value ? 0.125 : 0,
        child: Container(
          width: diameter,
          height: diameter,
          decoration: const BoxDecoration(
            color: Color(0xFF0E2330),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      openCloseDial: _dialOpen,
      overlayOpacity: 0.5,
      overlayColor: Colors.black,
      backgroundColor: Colors.transparent,
      elevation: 0,
      spacing: 10,
      spaceBetweenChildren: 10,
      children: actions
          .map((action) => SpeedDialChild(
        backgroundColor: const Color(0xFF0E2330),
        child: Icon(action.icon, color: Colors.white, size: 20),
        label: action.label,
        labelStyle:
        const TextStyle(color: Colors.white, fontSize: 14),
        labelBackgroundColor: Colors.transparent,
        onTap: () => GoRouter.of(context).push(action.route),
      ))
          .toList(),
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

  _ActionItem(
      {required this.icon, required this.label, required this.route});
}
