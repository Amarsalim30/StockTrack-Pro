enum StockStatus {
  available,
  lowStock,
  outOfStock,
  reserved,
  damaged,
  expired,
  inTransit,

  inStock,
  discontinued;

  String get displayName {
    switch (this) {
      case StockStatus.available:
        return 'Available';
      case StockStatus.lowStock:
        return 'Low Stock';
      case StockStatus.outOfStock:
        return 'Out of Stock';
      case StockStatus.reserved:
        return 'Reserved';
      case StockStatus.damaged:
        return 'Damaged';
      case StockStatus.expired:
        return 'Expired';
      case StockStatus.inTransit:
        return 'In Transit';
      case StockStatus.inStock:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.discontinued:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  String get code {
    switch (this) {
      case StockStatus.available:
        return 'AVAILABLE';
      case StockStatus.lowStock:
        return 'LOW_STOCK';
      case StockStatus.outOfStock:
        return 'OUT_OF_STOCK';
      case StockStatus.reserved:
        return 'RESERVED';
      case StockStatus.damaged:
        return 'DAMAGED';
      case StockStatus.expired:
        return 'EXPIRED';
      case StockStatus.inTransit:
        return 'IN_TRANSIT';
      case StockStatus.inStock:
        // TODO: Handle this case.
        throw UnimplementedError();
      case StockStatus.discontinued:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  static StockStatus fromString(String status) {
    return StockStatus.values.firstWhere(
      (e) => e.code == status.toUpperCase(),
      orElse: () => StockStatus.available,
    );
  }
}
