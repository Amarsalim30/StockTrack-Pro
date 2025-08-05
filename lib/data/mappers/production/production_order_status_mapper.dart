import 'package:clean_arch_app/data/models/production/production_order_status_model.dart';

class ProductionOrderStatusMapper {
  static ProductionOrderStatusModel toModel(String status) {
    return ProductionOrderStatusModel.fromString(status);
  }

  static String toEntity(ProductionOrderStatusModel model) {
    return model.name;
  }
}
