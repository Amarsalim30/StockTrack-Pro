import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:clean_arch_app/core/enums/stock_status.dart';

import '../../../domain/entities/stock/stock.dart';

class StockList extends StatefulWidget {
  final List<Stock> stocks;

  const StockList({super.key, required this.stocks});

  @override
  State<StockList> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  final Set<Stock> selectedStocks = {};

  bool get isAllSelected => selectedStocks.length == widget.stocks.length;

  void _toggleAllSelection(bool? value) {
    setState(() {
      if (value == true) {
        selectedStocks.addAll(widget.stocks);
      } else {
        selectedStocks.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stocks.isEmpty) {
      return const Center(child: Text('No stock items found.'));
    }

    return Column(
      children: [
        _buildHeaderRow(),
        const Divider(height: 1),
        Expanded(
          child: ListView.builder(
            itemCount: widget.stocks.length,
            itemBuilder: (context, index) {
              final stock = widget.stocks[index];
              return _buildStockRow(stock);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.grey[100],
      child: Row(
        children: [
          Checkbox(value: isAllSelected, onChanged: _toggleAllSelection),
          Expanded(
            flex: 5,
            child: Text(
              'ITEM DETAILS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STOCK',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              'Actions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockRow(Stock stock) {
    final bool isSelected = selectedStocks.contains(stock);

    Color statusColor;
    String statusText;

    switch (stock.status) {
      case StockStatus.available:
        statusColor = Colors.green;
        statusText = 'GOOD';
        break;
      case StockStatus.lowStock:
        statusColor = Colors.orange;
        statusText = 'LOW';
        break;
      case StockStatus.outOfStock:
        statusColor = Colors.red;
        statusText = 'CRITICAL';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'UNKNOWN';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey[100] : Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: isSelected,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  selectedStocks.add(stock);
                } else {
                  selectedStocks.remove(stock);
                }
              });
            },
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stock.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${stock.sku}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  stock.categoryId ?? '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Row(
                  children: [
                    Icon(Icons.location_pin, size: 12, color: Colors.grey),
                    Text(
                      stock.location ?? '',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${stock.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Min: ${stock.minimumStock}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value:
                      (stock.quantity /
                              (stock.minimumStock! > 0
                                  ? stock.minimumStock! * 2
                                  : 100))
                          .clamp(0.0, 1.0),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: const Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.black,
                ),
                onSelected: (value) {
                  // TODO: implement actions
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'view', child: Text('View Details')),
                  PopupMenuItem(value: 'edit', child: Text('Edit')),
                  PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
