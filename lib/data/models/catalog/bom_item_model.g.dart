// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bom_item_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BomItemModel _$BomItemModelFromJson(Map<String, dynamic> json) => BomItemModel(
  rawMaterialId: json['rawMaterialId'] as String,
  quantityPerUnit: (json['quantityPerUnit'] as num).toInt(),
);

Map<String, dynamic> _$BomItemModelToJson(BomItemModel instance) =>
    <String, dynamic>{
      'rawMaterialId': instance.rawMaterialId,
      'quantityPerUnit': instance.quantityPerUnit,
    };
