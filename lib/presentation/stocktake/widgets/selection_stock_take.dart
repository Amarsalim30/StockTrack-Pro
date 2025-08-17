import 'package:flutter/material.dart';

class FiltersSelection extends StatefulWidget {
  const FiltersSelection({Key? key}) : super(key: key);

  @override
  State<FiltersSelection> createState() => _FiltersSelectionState();
}

class _FiltersSelectionState extends State<FiltersSelection> {
  String countMode = "Full Count";
  String category = "All Categories";
  String location = "All Locations";
  String productionOrder = "All Orders";

  final List<String> countModes = ["Full Count", "Cycle Count","Partial Count"];
  final List<String> categories = ["All Categories", "Electronics", "Furniture"];
  final List<String> locations = ["All Locations", "Warehouse A", "Warehouse B"];
  final List<String> orders = ["All Orders", "PO1234", "PO5678"];

  void resetFilters() {
    setState(() {
      countMode = "Full Count";
      category = "All Categories";
      location = "All Locations";
      productionOrder = "All Orders";
    });
  }

  void startStockTake() {
    // Hook into your actual session logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Stock Take Session Started")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 500;

        return Container(
          width: isMobile ? double.infinity : 360,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(Icons.filter_alt_rounded, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Filters & Selection",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Filters
              _buildDropdown("Count Mode", countMode, countModes, (val) {
                setState(() => countMode = val!);
              }),
              _buildDropdown("Category", category, categories, (val) {
                setState(() => category = val!);
              }),
              _buildDropdown("Location", location, locations, (val) {
                setState(() => location = val!);
              }),
              _buildDropdown("Production Order", productionOrder, orders, (val) {
                setState(() => productionOrder = val!);
              }),

              const SizedBox(height: 24),

              // Actions
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: resetFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text("Reset"),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: startStockTake,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Start Stock Take Session",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Active Filters
              Text(
                "Active Filters",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _buildChip(countMode, colorScheme.primary),
                  _buildChip(category, colorScheme.secondary),
                  _buildChip(location, colorScheme.tertiary),
                  _buildChip(productionOrder, colorScheme.error),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildChip(String text, Color color) {
    return Chip(
      label: Text(text),
      avatar: Icon(Icons.check_circle, size: 18, color: color),
      onDeleted: () {
        // logic: reset that filter
      },
      deleteIcon: const Icon(Icons.close, size: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: color.withOpacity(0.12),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
