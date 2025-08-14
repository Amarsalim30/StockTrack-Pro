import 'package:clean_arch_app/core/enums/purchase_order_status.dart';
import 'package:clean_arch_app/presentation/purchase_order/purchase_order_view_model.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/order/purchase_order.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrder order;
  final PurchaseOrderViewModel viewModel;

  const PurchaseOrderCard({
    super.key,
    required this.order,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  order.id,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                _statusChip(PurchaseOrderStatus.fromString(order.status)),
                const Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "view") {
                      // navigate to view details
                    } else if (value == "cancel") {
                      viewModel.cancelPurchaseOrder(order.id, "User cancelled");
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: "view",
                      child: Row(
                        children: [
                          Icon(Icons.visibility, size: 18),
                          SizedBox(width: 8),
                          Text("View Details"),
                        ],
                      ),
                    ),
                    if (viewModel.canCancelPurchaseOrder)
                      const PopupMenuItem(
                        value: "cancel",
                        child: Row(
                          children: [
                            Icon(Icons.cancel, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              "Cancel Order",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Text(order.supplierId,
                style: const TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoColumn("Total Amount", "\$${order.totalAmount}"),
                const SizedBox(width: 16),
                _infoColumn("Items", order.items.length.toString()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _infoColumn("Created", _formatDate(order.createdAt)),
                const SizedBox(width: 16),
                _infoColumn("Last Modified", _formatDate(order.createdAt)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(PurchaseOrderStatus status) {
    Color color;
    String text;
    switch (status) {
      case PurchaseOrderStatus.draft:
        color = Colors.grey.shade300;
        text = "Draft";
        break;
      case PurchaseOrderStatus.pendingApproval:
        color = Colors.orange.shade200;
        text = "Pending Approval";
        break;
      case PurchaseOrderStatus.inProgress:
        color = Colors.blue.shade200;
        text = "In Progress";
        break;
      default:
        color = Colors.green.shade200;
        text = status.name;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12),
      ),
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.black54)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }
}
