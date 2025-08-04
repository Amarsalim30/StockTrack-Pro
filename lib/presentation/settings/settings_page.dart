import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_view_model.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Initialize settings on first build
    Future.microtask(() {
      ref.read(settingsViewModelProvider.notifier).init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            const Tab(icon: Icon(Icons.person), text: 'Profile'),
            const Tab(icon: Icon(Icons.settings), text: 'General'),
            const Tab(icon: Icon(Icons.security), text: 'Security'),
            if (state.isAdmin)
              const Tab(icon: Icon(Icons.storage), text: 'Data'),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                const _ProfileSection(),
                const _GeneralSettingsSection(),
                const _SecuritySection(),
                if (state.isAdmin) const _DataManagementSection(),
              ],
            ),
    );
  }
}

class _ProfileSection extends ConsumerWidget {
  const _ProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          // Avatar
          CircleAvatar(
            radius: 60,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            backgroundImage: state.avatarUrl.isNotEmpty
                ? NetworkImage(state.avatarUrl)
                : null,
            child: state.avatarUrl.isEmpty
                ? Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).primaryColor,
                  )
                : null,
          ),
          const SizedBox(height: 20),
          // Name
          Text(
            state.userName,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Email
          Text(
            state.userEmail,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: state.isAdmin ? Colors.orange : Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              state.userRole,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Profile Actions
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Navigate to edit profile
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Edit profile feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Change Photo'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Change photo action
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Change photo feature coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GeneralSettingsSection extends ConsumerWidget {
  const _GeneralSettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    final notifier = ref.read(settingsViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sync & Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Auto-Sync'),
                  subtitle: const Text(
                    'Automatically sync data when connected',
                  ),
                  value: state.autoSync,
                  onChanged: (value) {
                    notifier.setAutoSync(value);
                  },
                  secondary: const Icon(Icons.sync),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Low Stock Alerts'),
                  subtitle: const Text(
                    'Get notified when items are running low',
                  ),
                  value: state.lowStockAlerts,
                  onChanged: (value) {
                    notifier.setLowStockAlerts(value);
                  },
                  secondary: const Icon(Icons.warning),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Activity Notifications'),
                  subtitle: const Text(
                    'Receive updates about system activities',
                  ),
                  value: state.activityNotifications,
                  onChanged: (value) {
                    notifier.setActivityNotifications(value);
                  },
                  secondary: const Icon(Icons.notifications),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Display',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.palette),
                  title: const Text('Theme'),
                  subtitle: const Text('Light'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Theme selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Theme selection coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('Language'),
                  subtitle: const Text('English'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Language selection
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Language selection coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends ConsumerWidget {
  const _SecuritySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsViewModelProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Security',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Change Password'),
                  subtitle: const Text('Update your account password'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    notifier.changePassword();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password change feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Two-Factor Authentication'),
                  subtitle: const Text('Add an extra layer of security'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    notifier.setupTwoFactorAuth();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('2FA setup feature coming soon'),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.history),
                  title: const Text('Login History'),
                  subtitle: const Text('View recent login activities'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    notifier.viewLoginHistory();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Login history feature coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Privacy',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Settings'),
              subtitle: const Text('Manage your data and privacy'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Privacy settings feature coming soon'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _DataManagementSection extends ConsumerWidget {
  const _DataManagementSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(settingsViewModelProvider);
    final notifier = ref.read(settingsViewModelProvider.notifier);

    if (!state.isAdmin) {
      return const Center(child: Text('Admin access required'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange),
            ),
            child: Row(
              children: const [
                Icon(Icons.admin_panel_settings, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Admin-only features. Handle with care.',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Data Operations',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Export Data'),
                  subtitle: const Text('Download all system data as CSV/JSON'),
                  trailing: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await notifier.exportData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data export initiated'),
                              ),
                            );
                          },
                    child: const Text('Export'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync),
                  title: const Text('Force Sync'),
                  subtitle: const Text('Manually sync all data with server'),
                  trailing: ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                            await notifier.syncData();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data sync completed'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                    child: const Text('Sync'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text(
                    'Clear Local Data',
                    style: TextStyle(color: Colors.red),
                  ),
                  subtitle: const Text('Remove all cached data'),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: state.isLoading
                        ? null
                        : () {
                            _showClearDataDialog(context, notifier);
                          },
                    child: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'System Information',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('App Version'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Database Size'),
                  subtitle: const Text('23.5 MB'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.update),
                  title: const Text('Last Sync'),
                  subtitle: const Text('2 hours ago'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context, SettingsViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear Local Data'),
          content: const Text(
            'Are you sure you want to clear all local data? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(context).pop();
                final success = await viewModel.clearLocalData();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Local data cleared successfully'
                          : 'Failed to clear local data',
                    ),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              },
              child: const Text(
                'Clear Data',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}
