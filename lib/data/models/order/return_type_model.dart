import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/order/return_type.dart';

/// Mirrors the ReturnType enum in domain
@JsonEnum(alwaysCreate: true)
enum ReturnTypeModel {
  @JsonValue('supplier')
  supplier,
  @JsonValue('customer')
  customer,
  @JsonValue('warranty')
  warranty,
}

extension ReturnTypeModelExt on ReturnTypeModel {
  ReturnType toDomain() => ReturnType.values.byName(name);

  static ReturnTypeModel fromDomain(ReturnType t) =>
      ReturnTypeModel.values.byName(t.name);
}
