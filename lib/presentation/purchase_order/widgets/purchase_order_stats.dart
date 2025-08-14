import 'package:flutter/material.dart';
import '../../../core/enums/purchase_order_status.dart';
import '../purchase_order_state.dart';

class PurchaseOrderStats extends StatelessWidget {
  final PurchaseOrderState state;

  const PurchaseOrderStats({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final totalOrders = state.purchaseOrders.length;
    final pendingApproval = state.purchaseOrders
        .where((o) => o.status == PurchaseOrderStatus.pendingApproval)
        .length;
    final inProgress = state.purchaseOrders
        .where((o) => o.status == PurchaseOrderStatus.inProgress)
        .length;
    final totalValue = state.purchaseOrders.fold<double>(
      0,
          (sum, o) => sum + o.totalAmount,
    );

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _StatCard(
          title: "Total Orders",
          value: totalOrders.toString(),
          color: const Color(0xFF111827),
        ),
        _StatCard(
          title: "Pending Approval",
          value: pendingApproval.toString(),
          color: const Color(0xFFF97316),
        ),
        _StatCard(
          title: "In Progress",
          value: inProgress.toString(),
          color: const Color(0xFF2563EB),
        ),
        _StatCard(
          title: "Total Value",
          value: "\$${totalValue.toStringAsFixed(0)}",
          color: const Color(0xFF111827),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
