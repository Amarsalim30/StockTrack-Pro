import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    '/stock-take',
    '/suppliers',
    '/settings',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocation = GoRouter.of(context).state.matchedLocation;

    // Automatically sync selected index with route
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
    return Scaffold(
      body: widget.child,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // You can change this to suit your context
          context.push('/scan'); // Example: barcode scanner page
        },
        tooltip: 'Scan Barcode',
        child: const Icon(LucideIcons.scan_barcode),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.inventory),
              tooltip: 'Stock',
              onPressed: () => _onItemTapped(0),
              color: _selectedIndex == 0 ? Theme.of(context).colorScheme.primary : null,
            ),
            IconButton(
              icon: const Icon(Icons.insert_chart),
              tooltip: 'Stock Take',
              onPressed: () => _onItemTapped(1),
              color: _selectedIndex == 1 ? Theme.of(context).colorScheme.primary : null,
            ),
            IconButton(
              icon: const Icon(Icons.group),
              tooltip: 'Suppliers',
              onPressed: () => _onItemTapped(2),
              color: _selectedIndex == 2 ? Theme.of(context).colorScheme.primary : null,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () => _onItemTapped(3),
              color: _selectedIndex == 3 ? Theme.of(context).colorScheme.primary : null,
            ),
          ],
        ),
      ),
    );
  }
}
