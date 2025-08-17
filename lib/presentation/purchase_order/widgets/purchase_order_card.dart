import 'package:clean_arch_app/config/router/route_names.dart';
import 'package:clean_arch_app/core/enums/purchase_order_status.dart';
import 'package:clean_arch_app/presentation/purchase_order/purchase_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Navigate to details
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: ID, Status, Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "#${order.id}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _statusChip(PurchaseOrderStatus.fromString(order.status)),
                  PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == "view") {
                          context.pushNamed(
                            'purchaseOrderDetail',
                            pathParameters: {'id': order.id},
                            extra: order,
                          );


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

              const SizedBox(height: 6),
              Text(
                "Supplier: ${order.supplierId}",
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),

              const Divider(height: 20),

              // Info Row 1
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn("Total Amount", "\$${order.totalAmount}"),
                  _infoColumn("Items", order.items.length.toString()),
                ],
              ),

              const SizedBox(height: 8),

              // Info Row 2
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn("Created", _formatDate(order.createdAt)),
                  _infoColumn("Last Modified", _formatDate(order.createdAt)),
                ],
              ),
            ],
          ),
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
      case PurchaseOrderStatus.completed:
        color = Colors.green.shade200;
        text = "Completed";
        break;
      case PurchaseOrderStatus.cancelled:
        color = Colors.red.shade200;
        text = "Cancelled";
        break;
      default:
        color = Colors.grey.shade300;
        text = status.name;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration:
      BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
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
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.month}/${date.day}/${date.year}";
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Purchase Order"),
        content: const Text("Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              viewModel.cancelPurchaseOrder(order.id, "User cancelled");
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
