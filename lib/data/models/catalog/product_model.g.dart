// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
  id: json['id'] as String,
  name: json['name'] as String,
  sku: json['sku'] as String,
  description: json['description'] as String?,
  categoryId: json['categoryId'] as String,
  supplierId: json['supplierId'] as String,
  unitId: json['unitId'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  costPrice: (json['costPrice'] as num?)?.toDouble(),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  isActive: json['isActive'] as bool? ?? true,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'supplierId': instance.supplierId,
      'unitId': instance.unitId,
      'price': instance.price,
      'costPrice': instance.costPrice,
      'tags': instance.tags,
      'isActive': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
