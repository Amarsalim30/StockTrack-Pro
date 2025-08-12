import 'package:clean_arch_app/di/injection.dart' as di;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductionTopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback? onAccountTap;
  final VoidCallback? onSettingsTap;
  final Future<void> Function()? onLogout;

  const ProductionTopAppBar({
    Key? key,
    this.onAccountTap,
    this.onSettingsTap,
    this.onLogout,
  }) : super(key: key);

  static const _bgColor = Color(0xFF0E2330);
  static const double _height = 88.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep these reads minimal and purposeful
    final state = ref.watch(di.stockViewModelProvider);
    final notificationsState = ref.watch(di.notificationViewModelProvider);

    final unreadCount = notificationsState.unreadCount; // expects NotificationState.unreadCount getter
    final user = state.currentUser;
    final initials = _initialsFromUser(user);

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
              children: [
                const Text(
                  'StockPro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional Inventory Management',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Actions: notifications, avatar-as-menu
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

              // Avatar that opens the profile menu (replaces three-dot overflow)
              // PopupMenuButton has `child` parameter; using avatar as the trigger keeps built-in keyboard/semantic support.
              PopupMenuButton<_MenuAction>(
                color: Colors.white,
                tooltip: 'Account menu',
                // Use the avatar as the visible child that opens the menu
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

  Future<void> _handleMenuSelection({
    required BuildContext context,
    required WidgetRef ref,
    required _MenuAction action,
  }) async {
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
          Navigator.of(context).pushNamed('/settings');
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
