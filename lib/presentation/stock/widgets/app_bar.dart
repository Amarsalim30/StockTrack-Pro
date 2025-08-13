// presentation/stock/widgets/production_top_app_bar.dart
import 'package:clean_arch_app/core/enums/stock_status.dart';
import 'package:clean_arch_app/di/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Production-grade AppBar with:
/// - notification badge
/// - avatar-as-menu (account/settings/logout)
/// - select-mode toggle (shows checkboxes in the table)
/// - bulk action icons when select-mode is active (delete / mark status)
class ProductionTopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  // Optional callbacks to override default navigation/behaviour (useful for tests)
  final VoidCallback? onAccountTap;
  final VoidCallback? onSettingsTap;
  final Future<void> Function()? onLogout;

  /// Optional override: if provided, the widget will use this boolean
  /// instead of reading the provider directly. Useful for preview/tests.
  final bool? selectionActive;

  /// Optional override for toggling selection mode. If not provided,
  /// the widget will call stockViewModelProvider.notifier.toggleBulkSelectionMode()
  final VoidCallback? onToggleSelection;

  const ProductionTopAppBar({
    Key? key,
    this.onAccountTap,
    this.onSettingsTap,
    this.onLogout,
    this.selectionActive,
    this.onToggleSelection,
  }) : super(key: key);

  static const _bgColor = Color(0xFF0E2330);
  static const double _height = 88.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Minimal provider reads:
    final stockState = ref.watch(di.stockViewModelProvider);
    final stockVm = ref.read(di.stockViewModelProvider.notifier);
    final notificationsState = ref.watch(di.notificationViewModelProvider);

    final unreadCount = notificationsState.unreadCount;
    final user = stockState.currentUser;
    final initials = _initialsFromUser(user);

    // Determine whether selection mode is active (prop overrides provider)
    final bool active = selectionActive ?? stockState.isBulkSelectionMode;

    return AppBar(
      backgroundColor: _bgColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: _height,
      titleSpacing: 18,
      title: Row(
        children: [
          // Title block
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'StockPro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Professional Inventory Management',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Actions area
          Row(
            children: [
              // Notifications with badge
              _NotificationButton(
                unreadCount: unreadCount,
                onTap: () {
                  Navigator.of(context).pushNamed('/notifications');
                },
              ),

              const SizedBox(width: 10),

              // SELECT MODE TOGGLE (entry/exit)
              Tooltip(
                message: active ? 'Exit selection mode' : 'Select items',
                child: IconButton(
                  onPressed: () {
                    if (onToggleSelection != null) {
                      onToggleSelection!();
                    } else {
                      stockVm.toggleBulkSelectionMode();
                    }
                    // Optional: announce for accessibility
                    // SemanticsService.announce(active ? 'Selection mode off' : 'Selection mode on', TextDirection.ltr);
                  },
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) {
                      return RotationTransition(turns: anim, child: child);
                    },
                    child: Icon(
                      active ? Icons.close : Icons.select_all,
                      key: ValueKey<bool>(active),
                      color: Colors.white70,
                    ),
                  ),
                  tooltip: active ? 'Exit selection mode' : 'Select items',
                ),
              ),

              const SizedBox(width: 8),

              // When in selection mode show bulk action icons (delete + mark status)
              if (active) ...[
                // Bulk delete
                IconButton(
                  onPressed: () async {
                    final confirmed = await _confirmBulkDelete(context);
                    if (!confirmed) return;
                    // call ViewModel bulk delete
                    await stockVm.bulkDelete();
                  },
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white70,
                  tooltip: 'Delete selected items',
                ),

                const SizedBox(width: 8),
              ],

              // Avatar used as menu trigger (Account / Settings / Logout)
              PopupMenuButton<_MenuAction>(
                color: Colors.white,
                tooltip: 'Account menu',
                child: Semantics(
                  label: 'Account menu',
                  button: true,
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: _bgColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onSelected: (action) => _handleMenuSelection(
                  context: context,
                  ref: ref,
                  action: action,
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _MenuAction.account,
                    child: ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: const Text('Account'),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  PopupMenuItem(
                    value: _MenuAction.settings,
                    child: ListTile(
                      leading: const Icon(Icons.settings_outlined),
                      title: const Text('Settings'),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: _MenuAction.logout,
                    child: ListTile(
                      leading: const Icon(Icons.logout_outlined, color: Colors.redAccent),
                      title: const Text('Logout', style: TextStyle(color: Colors.redAccent)),
                      dense: true,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Future<bool> _confirmBulkDelete(BuildContext context) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete selected items'),
        content: const Text('Are you sure you want to delete all selected items? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    return res == true;
  }

  Future<void> _handleMenuSelection({
    required BuildContext context,
    required WidgetRef ref,
    required _MenuAction action,
  }) async {
    final stockVm = ref.read(di.stockViewModelProvider.notifier);

    switch (action) {
      case _MenuAction.account:
        if (onAccountTap != null) {
          onAccountTap!();
        } else {
          Navigator.of(context).pushNamed('/account');
        }
        break;

      case _MenuAction.settings:
        if (onSettingsTap != null) {
          onSettingsTap!();
        } else {
          context.go('/settings');
        }
        break;

      case _MenuAction.logout:
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Logout')),
            ],
          ),
        );

        if (confirm == true) {
          if (onLogout != null) {
            await onLogout!();
          } else {
            try {
              // Default behavior: navigate to login (adjust to your auth logic)
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            } catch (_) {
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          }

          if (ScaffoldMessenger.maybeOf(context) != null) {
            ScaffoldMessenger.of(context)!.showSnackBar(
              const SnackBar(content: Text('Logged out')),
            );
          }
        }
        break;
    }
  }

  static IconData _statusIconForMenu(StockStatus s) {
    switch (s) {
      case StockStatus.lowStock:
        return Icons.warning_amber_rounded;
      case StockStatus.outOfStock:
        return Icons.remove_circle_outline;
      case StockStatus.inStock:
        return Icons.check_circle_outline;
      case StockStatus.discontinued:
        return Icons.block;
      default:
        return Icons.info_outline;
    }
  }

  static String _initialsFromUser(dynamic user) {
    try {
      final name = (user?.name ?? user?.displayName ?? '') as String;
      if (name.trim().isEmpty) return 'U';
      final parts = name.trim().split(RegExp(r'\s+'));
      if (parts.length == 1) return parts[0][0].toUpperCase();
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } catch (_) {
      return 'U';
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(_height);
}

enum _MenuAction { account, settings, logout }

/// Small notification button with badge; kept separate to minimize rebuild surface.
class _NotificationButton extends StatelessWidget {
  final int unreadCount;
  final VoidCallback onTap;
  const _NotificationButton({Key? key, required this.unreadCount, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          onPressed: onTap,
          icon: const Icon(Icons.notifications_none),
          color: Colors.white70,
          tooltip: 'Notifications',
        ),
        if (unreadCount > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Text(
                unreadCount > 9 ? '9+' : '$unreadCount',
                style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}
