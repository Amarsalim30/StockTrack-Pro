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
  price: (json['price'] as num?)?.toDouble(),
  costPrice: (json['costPrice'] as num?)?.toDouble(),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'supplierId': instance.supplierId,
      'price': instance.price,
      'costPrice': instance.costPrice,
      'tags': instance.tags,
    };
