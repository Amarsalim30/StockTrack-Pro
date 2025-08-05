import 'package:clean_arch_app/data/models/production/production_order_status_model.dart';

import 'package:clean_arch_app/domain/entities/production/production_order_status.dart';
class ProductionOrderStatusMapper {
  static ProductionOrderStatusModel toModel(ProductionOrderStatus entity) {
    return ProductionOrderStatusModel.fromString(entity.name);
  }

  static ProductionOrderStatus toEntity(ProductionOrderStatusModel model) {
    return ProductionOrderStatus(
      name: model.name,
    );
  }
}
