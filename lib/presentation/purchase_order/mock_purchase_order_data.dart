import '../../domain/entities/order/purchase_order.dart';
import '../../domain/entities/order/purchase_order_item.dart';
import '../../core/enums/purchase_order_status.dart';

final mockPurchaseOrders = [
  PurchaseOrder(
    id: "PO-2024-004",
    supplierId: "Office Supplies Co.",
    createdByUserId: "user-1",
    approvedByUserId: null,
    goodsReceiptId: null,
    invoiceId: null,
    totalAmount: 890,
    attachments: [],
    createdAt: DateTime(2024, 1, 16),
    expectedDeliveryDate: DateTime(2024, 1, 22),
    receivedDate: null,
    status: PurchaseOrderStatus.draft.toString(),
    items: [
      PurchaseOrderItem(
        stockId: "stk-006",
        quantityOrdered: 10,
        unitCost: 5,
      ),
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
    ],
    notes: "Office supplies order",
  ),
  PurchaseOrder(
    id: "PO-2024-003",
    supplierId: "Furniture Direct",
    createdByUserId: "user-2",
    approvedByUserId: null,
    goodsReceiptId: null,
    invoiceId: null,
    totalAmount: 2450,
    attachments: [],
    createdAt: DateTime(2024, 1, 16),
    expectedDeliveryDate: DateTime(2024, 1, 30),
    receivedDate: null,
    status: PurchaseOrderStatus.pendingApproval.toString(),
    items: [
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
    ],
    notes: "Office furniture order",
  ),
  PurchaseOrder(
    id: "PO-2024-002",
    supplierId: "Tech Warehouse",
    createdByUserId: "user-1",
    approvedByUserId: "manager-1",
    goodsReceiptId: null,
    invoiceId: null,
    totalAmount: 3000,
    attachments: [],
    createdAt: DateTime(2024, 1, 15),
    expectedDeliveryDate: DateTime(2024, 1, 25),
    receivedDate: null,
    status: PurchaseOrderStatus.inProgress.toString(),
    items: [
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
    ],
    notes: "Computers and accessories",
  ),
  PurchaseOrder(
    id: "PO-2024-001",
    supplierId: "Stationery World",
    createdByUserId: "user-3",
    approvedByUserId: "manager-1",
    goodsReceiptId: null,
    invoiceId: null,
    totalAmount: 1750,
    attachments: [],
    createdAt: DateTime(2024, 1, 14),
    expectedDeliveryDate: DateTime(2024, 1, 21),
    receivedDate: null,
    status: PurchaseOrderStatus.inProgress.toString(),
    items: [
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
      PurchaseOrderItem(
        stockId: "stk-001",
        quantityOrdered: 50,
        unitCost: 1,
      ),
    ],
    notes: "Bulk stationery order",
  ),
];
