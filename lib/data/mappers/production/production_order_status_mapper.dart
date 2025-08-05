import 'package:clean_arch_app/data/models/production/production_order_status_model.dart';

import '../../models/production/production_order_model.dart';

class ProductionOrderStatusMapper {
  static ProductionOrderStatusModel toModel(ProductionOrderStatus entity) {
    return ProductionOrderStatusModel(
      id: entity.id,
      name: entity.name,
      color: entity.color,
      isDefault: entity.isDefault,
      isFinal: entity.isFinal,
    );
  }

  static ProductionOrderStatus toEntity(ProductionOrderStatusModel model) {
    return ProductionOrderStatus(
      id: model.id,
      name: model.name,
      color: model.color,
      isDefault: model.isDefault,
      isFinal: model.isFinal,
    );
  }
}
