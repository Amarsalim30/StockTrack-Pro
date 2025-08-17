// lib/core/enums/purchase_order_status.dart
enum PurchaseOrderStatus {
  draft,
  pendingApproval,
  inProgress,
  completed,
  cancelled,

  pending,
  approved;

  String get code {
  switch (this) {

    case PurchaseOrderStatus.draft:
      return 'DRAFT';
      case PurchaseOrderStatus.pendingApproval:
       return 'PENDING_APPROVAL';
       case PurchaseOrderStatus.inProgress:
         return 'IN_PROGRESS';
         case PurchaseOrderStatus.completed:
           return 'COMPLETED';
           case PurchaseOrderStatus.cancelled:
             return 'CANCELLED';
    case PurchaseOrderStatus.pending:
      return 'PENDING_APPROVAL';
    case PurchaseOrderStatus.approved:
      return 'PENDING_APPROVAL';

  }
}


  static PurchaseOrderStatus fromString(String status) {
  return PurchaseOrderStatus.values.firstWhere(
        (e) => e.code == status.toUpperCase(),
    orElse: () => PurchaseOrderStatus.draft,
  );
}
}
