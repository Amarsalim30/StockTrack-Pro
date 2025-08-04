// lib/data/models/catalog/bom_item_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/catalog/bom_item.dart';

part 'bom_item_model.g.dart';

@JsonSerializable()
class BomItemModel extends Equatable {
  final String rawMaterialId;
  final int quantityPerUnit;

  const BomItemModel({
    required this.rawMaterialId,
    required this.quantityPerUnit,
  });

  factory BomItemModel.fromJson(Map<String, dynamic> json) =>
      _$BomItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$BomItemModelToJson(this);

  BomItem toDomain() =>
      BomItem(rawMaterialId: rawMaterialId, quantityPerUnit: quantityPerUnit);

  static BomItemModel fromDomain(BomItem e) => BomItemModel(
    rawMaterialId: e.rawMaterialId,
    quantityPerUnit: e.quantityPerUnit,
  );

  @override
  List<Object?> get props => [rawMaterialId, quantityPerUnit];
}
