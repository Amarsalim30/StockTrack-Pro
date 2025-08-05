import 'package:clean_arch_app/data/models/production/production_order_status_model.dart';
import 'package:json_annotation/json_annotation.dart';

class ProductionOrderStatusModelConverter
    implements JsonConverter<ProductionOrderStatusModel, String> {
  const ProductionOrderStatusModelConverter();

  @override
  ProductionOrderStatusModel fromJson(String json) {
    return ProductionOrderStatusModel.fromString(json);
  }

  @override
  String toJson(ProductionOrderStatusModel object) {
    return object.name;
  }
}
