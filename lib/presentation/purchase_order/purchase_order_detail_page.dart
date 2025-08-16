import 'package:clean_arch_app/presentation/purchase_order/approval_progress_item.dart';
import 'package:clean_arch_app/presentation/purchase_order/widgets/build_activity_content.dart';
import 'package:clean_arch_app/presentation/purchase_order/widgets/build_invoice_content.dart';
import 'package:clean_arch_app/presentation/stock/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/order/purchase_order.dart';

class PurchaseOrderDetailPage extends StatefulWidget {
  final PurchaseOrder order;

  const PurchaseOrderDetailPage({super.key, required this.order});

  @override
  State<PurchaseOrderDetailPage> createState() =>
      _PurchaseOrderDetailPageState();
}

class _PurchaseOrderDetailPageState extends State<PurchaseOrderDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    // Inside _PurchaseOrderDetailPageState build():
    return Scaffold(
      appBar: ProductionTopAppBar(),
      body: Column(
        children: [
          // Header section
          Material(
            elevation: 1,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              order.id,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            _statusChip("Normal", Colors.blue.shade100),
                            const SizedBox(width: 4),
                            _statusChip("Approved", Colors.green.shade100),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.supplierId,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert, size: 18),
                    label: const Text("Actions"),
                  ),
                ],
              ),
            ),
          ),

          // Tabs
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              indicatorColor: Colors.blue,
              tabs: const [
                Tab(text: "PO Details"),
                Tab(text: "Approval"),
                Tab(text: "Goods Receipt"),
                Tab(text: "Invoice"),
                Tab(text: "Activity"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPoDetails(order),
                _buildApprovalContent(order),
                _buildGoodsReceiptContent(order),
                InvoicePage(),
                activityCard(
                  "Activity Log",
                  [
                    ActivityItem(
                      description: "Purchase Order #PO1234 approved by John Doe",
                      timestamp: "Aug 16, 2025 10:45 AM",
                      dotColor: Colors.green,
                    ),
                    ActivityItem(
                      description: "Goods received at Warehouse 2",
                      timestamp: "Aug 15, 2025 4:12 PM",
                      dotColor: Colors.blue,
                    ),
                    ActivityItem(
                      description: "Invoice #INV567 issued",
                      timestamp: "Aug 15, 2025 1:05 PM",
                      dotColor: Colors.orange,
                    ),
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGoodsReceiptContent(PurchaseOrder order) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0.5,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Goods Receipt Status",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 10),

                // Scrollable horizontal DataTable
                SizedBox(
                  child: Scrollbar(
                    radius: const Radius.circular(12),
                    thickness: 8,
                    thumbVisibility: true,
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowHeight: 36,
                        dataRowMinHeight: 44,
                        horizontalMargin: 12,
                        columnSpacing: 28,
                        border: TableBorder.all(
                          color: Colors.grey.shade300,
                          width: 0.6,
                        ),
                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        columns: const [
                          DataColumn(label: Text('Item')),
                          DataColumn(label: Text('Ordered')),
                          DataColumn(label: Text('Received')),
                          DataColumn(label: Text('Remaining')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: [
                          _goodsReceiptRow("Office Paper A4", 50, 50, 0, "Complete"),
                          _goodsReceiptRow("Ballpoint Pens (Pack of 10)", 25, 25, 0, "Complete"),
                          _goodsReceiptRow("Desk Organizer", 10, 10, 0, "Complete"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DataRow _goodsReceiptRow(
      String item, int ordered, int received, int remaining, String status) {
    return DataRow(
      cells: [
        DataCell(Text(item)),
        DataCell(Text(ordered.toString())),
        DataCell(Text(received.toString())),
        DataCell(Text(remaining.toString())),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              status,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalContent(PurchaseOrder order) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // Approval Workflow
        infoCard(
          "Approval Workflow",
          [
            ApprovalProgressItem(
              approverName: "Mike Wilson",
              level: "Level 1",
              dateApproved: "2024-01-11",
              statusLabel: "Approved",
              statusColor: Colors.green.shade100,
              note: "Approved for standard office supplies",
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Approval Rules
        infoCard(
          "Approval Rules",
          [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orange, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Purchase orders over \$1,000 require approval",
                        style:
                        TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Level 1: Department Manager • Level 2: Finance Director (if over \$5,000)",
                        style: TextStyle(
                            fontSize: 13, color: Colors.black87, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }


  // Refined chip style
  Widget _statusChip(String text, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

// PO details with improved table
  Widget _buildPoDetails(PurchaseOrder order) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        infoCard("Supplier Information", const [
          _DetailItem(label: "Contact Person", value: "John Smith"),
          _DetailItem(label: "Email", value: "john@officesupplies.com"),
          _DetailItem(label: "Phone", value: "+1 (555) 123-4567"),
          _DetailItem(
              label: "Address", value: "123 Business Ave, City, State 12345"),
        ]),
        infoCard("Order Information", const [
          _DetailItem(label: "Expected Delivery", value: "2024-01-15"),
          _DetailItem(label: "Created By", value: "John Kimi"),
          _DetailItem(label: "Approved By", value: "Mike Wilson"),
        ]),
        _tableCard(),
      ],
    );
  }

  Widget infoCard(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
  Widget _tableCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card title
            const Text(
              "Order Items",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 10),

            // Scrollable table
            SizedBox(
              child: Scrollbar(
                interactive: true,
                radius: const Radius.circular(12),
                thickness: 8,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowHeight: 36,
                    dataRowMinHeight: 44,
                    horizontalMargin: 12,
                    columnSpacing: 28,
                    border: TableBorder.all(
                        color: Colors.grey.shade300, width: 0.6),
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87),
                    columns: const [
                      DataColumn(label: Text('Item')),
                      DataColumn(label: Text('PO Qty')),
                      DataColumn(label: Text('Received')),
                      DataColumn(label: Text('Invoiced')),
                      DataColumn(label: Text('PO Price')),
                    ],
                    rows: [
                      _dataRow("Office Paper A4", 50, 50, 50, "\$12.00"),
                      _dataRow(
                          "Ballpoint Pens (Pack of 10)", 25, 25, 25, "\$8.50"),
                      _dataRow("Desk Organizer", 10, 10, 10, "\$42.50"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _dataRow(String item, int poQty, int received, int invoiced,
      String price) {
    return DataRow(cells: [
      DataCell(Text(item)),
      DataCell(Text(poQty.toString())),
      DataCell(Text(received.toString())),
      DataCell(Text(invoiced.toString())),
      DataCell(Text(price)),
    ]);
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

