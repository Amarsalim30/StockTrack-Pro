enum ProductionOrderStatusModel {
  pending('pending'),
  inProgress('inProgress'),
  completed('completed'),
  cancelled('cancelled'),
  paused('paused');

  final String name;
  const ProductionOrderStatusModel(this.name);

  @override
  String toString() => name;

  static ProductionOrderStatusModel fromString(String value) {
    return ProductionOrderStatusModel.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ProductionOrderStatusModel.pending,
    );
  }
}
