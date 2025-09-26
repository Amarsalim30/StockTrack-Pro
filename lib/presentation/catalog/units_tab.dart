
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/general/unit.dart';
import '../../../di/injection.dart';
import 'unit/unit_dialog.dart';

class UnitsTab extends ConsumerWidget {
  const UnitsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitsState = ref.watch(unitViewModelProvider);
    final vm = ref.read(unitViewModelProvider.notifier);

    final isLoading = unitsState.isLoading;
    final units = unitsState.displayUnits;
    final hasError = unitsState.hasError;
    final error = unitsState.error;

    return Column(
      children: [
        // Search & Filter Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: vm.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search units...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.filter_list_rounded),
                onPressed: () {
                  // TODO: open filter modal
                },
              ),
            ],
          ),
        ),

        // Error Banner
        if (hasError)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.red[200]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    error!,
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: vm.clearError,
                  child: Text('Dismiss', style: TextStyle(color: Colors.red[700])),
                ),
              ],
            ),
          ),

        // Add Unit Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Unit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E2330),
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                onPressed: () => _showUnitDialog(context, vm),
              ),
            ],
          ),
        ),

        // Units List
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: RefreshIndicator(
              onRefresh: vm.fetchAllUnits,
              child: isLoading && units.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : units.isEmpty
                  ? _buildEmptyState(context, vm)
                  : ListView.separated(
                itemCount: units.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final unit = units[index];
                  return _unitCard(context, unit, vm);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _unitCard(BuildContext context, Unit unit, dynamic vm) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Unit Name + Actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    unit.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showUnitDialog(context, vm, unit: unit);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(context, vm, unit);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                  icon: const Icon(Icons.more_vert, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Metadata
            Wrap(
              spacing: 12,
              runSpacing: 6,
              children: [
                _chipLabel('ID', unit.id),
                if (unit.conversionRate != null)
                  _chipLabel('Rate', unit.conversionRate!.toString()),
              ],
            ),

            if (unit.description != null && unit.description!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                unit.description!,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chipLabel(String label, String value) {
    return Chip(
      label: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildEmptyState(BuildContext context, dynamic vm) {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.straighten_outlined, size: 48, color: Colors.grey.shade400),
              const SizedBox(height: 12),
              Text(
                'No units found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w700
                )
              ),
              const SizedBox(height: 6),
              Text(
                'Add measurement units for your products',
                style: TextStyle(color: Colors.grey.shade500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add First Unit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E2330),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: () => _showUnitDialog(context, vm),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showUnitDialog(BuildContext context, dynamic vm, {Unit? unit}) {
    showDialog(
      context: context,
      builder: (context) => UnitDialog(
        unit: unit,
        onSubmit: (unitData) {
          if (unit == null) {
            vm.createUnit(unitData);
          } else {
            vm.updateUnit(unitData);
          }
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic vm, Unit unit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Unit'),
        content: Text('Are you sure you want to delete "${unit.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              vm.deleteUnit(unit.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}