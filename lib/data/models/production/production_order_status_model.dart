class ProductionOrderStatusModel {
  final String name;

  const ProductionOrderStatusModel(this.name);

  static const ProductionOrderStatusModel pending = ProductionOrderStatusModel(
    'pending',
  );
  static const ProductionOrderStatusModel inProgress =
      ProductionOrderStatusModel('inProgress');
  static const ProductionOrderStatusModel completed =
      ProductionOrderStatusModel('completed');
  static const ProductionOrderStatusModel cancelled =
      ProductionOrderStatusModel('cancelled');
  static const ProductionOrderStatusModel paused = ProductionOrderStatusModel(
    'paused',
  );

  @override
  String toString() => name;

  List<ProductionOrderStatusModel> get values => [
    pending,
    inProgress,
    completed,
    cancelled,
    paused,
  ];
}
