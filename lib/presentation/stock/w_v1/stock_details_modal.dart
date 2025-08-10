// lib/presentation/stock/widgets/stock_details_modal.dart

import 'package:flutter/material.dart';
import '../../../domain/entities/stock/stock.dart';
import 'styles.dart';

class StockDetailsModal extends StatelessWidget {
  final Stock stock;

  const StockDetailsModal({
    Key? key,
    required this.stock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = (stock.quantity / stock.minQuantity).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.all(StockStyles.spaceLG),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stock.name,
            style: StockStyles.title.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: StockStyles.spaceSM),
          Row(
            children: [
              Text('Quantity: ${stock.quantity}'),
              const Spacer(),
              Text('Min: ${stock.minQuantity}'),
            ],
          ),
          const SizedBox(height: StockStyles.spaceSM),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: StockStyles.progressBackground,
            valueColor: AlwaysStoppedAnimation(
              progress < 0.3 ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(height: StockStyles.spaceMD),
          Row(
            children: [
              Text(
                'Status:',
                style: StockStyles.caption,
              ),
              const SizedBox(width: StockStyles.spaceSM),
              Chip(
                label: Text(stock.status.name),
                backgroundColor: stock.status.color,
              ),
            ],
          ),
          const SizedBox(height: StockStyles.spaceLG),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ),
        ],
      ),
    );
  }
}
