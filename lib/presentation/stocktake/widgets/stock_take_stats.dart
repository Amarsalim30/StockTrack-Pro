import 'package:stocktrack_pro/presentation/stock/stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/purchase_order_status.dart';
import '../../../di/injection.dart';
import '../../stock/stock_state.dart';
import '../stocktake_view_model.dart';

class StockTakeStats extends ConsumerWidget {

  const StockTakeStats({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final state = ref.watch(stockViewModelProvider);
    final totalOrders = state.stocks.length;
    final counted = 15;
    final remaining = 85;
    final discrepancies = 5;

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
          title: "Counted",
          value: counted.toString(),
          color: const Color(0xFFF97316),
        ),
        _StatCard(
          title: "Remaining",
          value: remaining.toString(),
          color: const Color(0xFF2563EB),
        ),
        _StatCard(
          title: "Discrepancies",
          value: discrepancies.toString(),
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
        border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
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
