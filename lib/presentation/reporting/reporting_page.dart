import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProductionTopAppBar(),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section Title & Actions
            Text(
              "Reports",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              "Generate, schedule, and manage business reports",
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildPillAction(Icons.history, "History"),
                const SizedBox(width: 8),
                _buildPillAction(Icons.flash_on, "Quick Reports"),
                const SizedBox(width: 8),
                _buildPillAction(Icons.play_arrow, "Generate Now"),
              ],
            ),

            const SizedBox(height: 24),

            // Quick Business Reports Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quick Business Reports",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  "• Ready in under 30 seconds",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Quick Business Report Cards
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildReportCard(Icons.warning_amber_rounded, Colors.red,
                    "Low Stock Alert", "Items below reorder point"),
                _buildReportCard(Icons.trending_up, Colors.green,
                    "Today's Movement", "All transactions today"),
                _buildReportCard(Icons.bar_chart, Colors.blue,
                    "Stock Valuation", "Current inventory value"),
                _buildReportCard(Icons.inventory, Colors.purple,
                    "Dead Stock", "90+ days no movement"),
              ],
            ),

            const SizedBox(height: 24),

            // Custom Report Builder
            _buildCustomCard(),

            const SizedBox(height: 24),

            // Filters (example UI for date/location/category)
            Text("Select report type",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildFilterChip("This Month", true),
                _buildFilterChip("Last Month", false),
                _buildFilterChip("Quarter", false),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildDateField("mm/dd/yyyy"),
                const SizedBox(width: 8),
                _buildDateField("mm/dd/yyyy"),
              ],
            ),
            const SizedBox(height: 8),
            _buildDropdown("All locations"),
            const SizedBox(height: 8),
            _buildDropdown("All categories"),

            const SizedBox(height: 24),

            // Generate Buttons
            Row(
              children: [
                _buildPrimaryButton("Preview First"),
                const SizedBox(width: 8),
                _buildPrimaryButton("Generate Report"),
                const SizedBox(width: 8),
                _buildSecondaryButton("Save as Template"),
              ],
            ),

            const SizedBox(height: 24),

            // Saved Templates
            Text("Saved Templates",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildTemplateItem(
              "Monthly Stock Valuation",
              "Used 12x • Main Warehouse • Last 30 days",
              "Last run: 2 days ago ✓",
            ),
            _buildTemplateItem(
              "Weekly Dead Stock",
              "Used 8x • All locations • 90+ days",
              "Last run: 1 week ago ✓",
            ),
            _buildTemplateItem(
              "Supplier Performance",
              "Used 4x • Top 10 suppliers • Quarterly",
              "Last run: 3 weeks ago",
            ),

            const SizedBox(height: 24),

            // Scheduled Reports
            Text("Scheduled Reports",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildScheduleItem(
              "Monthly Inventory",
              "Next run: Feb 1, 2024 at 9:00 AM",
              "Sent to: finance@company.com",
            ),
            _buildScheduleItem(
              "Weekly Stock Movement",
              "Next run: Monday at 9:00 AM",
              "Sent to: operations@company.com",
            ),
            const SizedBox(height: 8),
            _buildSecondaryButton("Schedule New Report"),

            const SizedBox(height: 24),

            // Recent Reports
            Text("Recent Reports",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            _buildRecentReport(
              "Stock Valuation Report",
              "2.3 MB • Generated 2 hours ago • Main Warehouse • Jan 1-31, 2024",
            ),
            _buildRecentReport(
              "Dead Stock Analysis",
              "1.8 MB • Generated 5 hours ago • All locations • 147 items identified",
            ),
            const SizedBox(height: 12),
            _buildSecondaryButton("View All History"),
          ],
        ),
      ),
    );
  }

  // Pill Action Button
  Widget _buildPillAction(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(fontSize: 13, color: Colors.grey[800])),
        ],
      ),
    );
  }

  // Report Card
  Widget _buildReportCard(
      IconData icon, Color color, String title, String subtitle) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // Custom Report Builder
  Widget _buildCustomCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Custom Report Builder",
                    style:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text("Est. 2-5 min",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const SizedBox(height: 6),
                Text("Configure parameters for detailed analysis reports",
                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Filter Chip
  Widget _buildFilterChip(String label, bool selected) {
    return FilterChip(
      selected: selected,
      label: Text(label),
      onSelected: (_) {},
      selectedColor: Colors.blue[50],
      checkmarkColor: Colors.blue,
      labelStyle: TextStyle(
        color: selected ? Colors.blue[700] : Colors.grey[700],
      ),
    );
  }

  // Date Field
  Widget _buildDateField(String placeholder) {
    return Expanded(
      child: TextField(
        decoration: InputDecoration(
          hintText: placeholder,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  // Dropdown
  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: label,
          items: [label].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  // Primary Button
  Widget _buildPrimaryButton(String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }

  // Secondary Button
  Widget _buildSecondaryButton(String text) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blue[700],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: BorderSide(color: Colors.blue[300]!),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      onPressed: () {},
      child: Text(text),
    );
  }

  // Template Item
  Widget _buildTemplateItem(String title, String subtitle, String runInfo) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(runInfo, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        ],
      ),
    );
  }

  // Schedule Item
  Widget _buildScheduleItem(String title, String nextRun, String email) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Text(nextRun, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(email, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }

  // Recent Report Item
  Widget _buildRecentReport(String title, String details) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          const SizedBox(height: 2),
          Text(details, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
