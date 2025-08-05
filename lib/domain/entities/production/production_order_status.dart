class ProductionOrderStatus {
  final String name;

  const ProductionOrderStatus._(this.name);

  static const ProductionOrderStatus pending = ProductionOrderStatus._(
    'pending',
  );
  static const ProductionOrderStatus inProgress = ProductionOrderStatus._(
    'in_progress',
  );
  static const ProductionOrderStatus completed = ProductionOrderStatus._(
    'completed',
  );
  static const ProductionOrderStatus cancelled = ProductionOrderStatus._(
    'cancelled',
  );
  static const ProductionOrderStatus paused = ProductionOrderStatus._('paused');

  @override
  String toString() => name;

  static List<ProductionOrderStatus> get values => [
    pending,
    inProgress,
    completed,
    cancelled,
  ];
}
