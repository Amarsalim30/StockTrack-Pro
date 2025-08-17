import 'add_item_to_purchase_order.dart';
import 'receive_purchase_order_item.dart';
import 'update_purchase_order_item.dart';
import 'remove_purchase_order_item.dart';
import 'mark_item_as_fully_received.dart';

class PurchaseOrderItemUseCases {
  final AddItemToPurchaseOrder addItem;
  final ReceivePurchaseOrderItem receiveItem;
  final UpdatePurchaseOrderItem updateItem;
  final RemovePurchaseOrderItem removeItem;
  final MarkItemAsFullyReceived markAsFullyReceived;

  PurchaseOrderItemUseCases({
    required this.addItem,
    required this.receiveItem,
    required this.updateItem,
    required this.removeItem,
    required this.markAsFullyReceived,
  });
}
