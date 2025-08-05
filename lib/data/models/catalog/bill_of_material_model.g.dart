// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_of_material_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BillOfMaterialsModel _$BillOfMaterialsModelFromJson(
  Map<String, dynamic> json,
) => BillOfMaterialsModel(
  productId: json['productId'] as String,
  components: (json['components'] as List<dynamic>)
      .map((e) => BomItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  yieldPerRun: (json['yieldPerRun'] as num?)?.toInt() ?? 1,
  scrapPercent: (json['scrapPercent'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$BillOfMaterialsModelToJson(
  BillOfMaterialsModel instance,
) => <String, dynamic>{
  'productId': instance.productId,
  'components': instance.components.map((e) => e.toJson()).toList(),
  'yieldPerRun': instance.yieldPerRun,
  'scrapPercent': instance.scrapPercent,
};
