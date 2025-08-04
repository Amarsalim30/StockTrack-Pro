// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_take_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockTakeModel _$StockTakeModelFromJson(Map<String, dynamic> json) =>
    StockTakeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      status: $enumDecode(_$StockTakeStatusEnumMap, json['status']),
      createdBy: json['createdBy'] as String,
      assignedTo: (json['assignedTo'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      locationId: json['locationId'] as String?,
      categoryFilters: (json['categoryFilters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      totalItems: (json['totalItems'] as num).toInt(),
      countedItems: (json['countedItems'] as num).toInt(),
      discrepancies: (json['discrepancies'] as num).toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$StockTakeModelToJson(StockTakeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'status': _$StockTakeStatusEnumMap[instance.status]!,
      'createdBy': instance.createdBy,
      'assignedTo': instance.assignedTo,
      'locationId': instance.locationId,
      'categoryFilters': instance.categoryFilters,
      'totalItems': instance.totalItems,
      'countedItems': instance.countedItems,
      'discrepancies': instance.discrepancies,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$StockTakeStatusEnumMap = {
  StockTakeStatus.active: 'active',
  StockTakeStatus.paused: 'paused',
  StockTakeStatus.completed: 'completed',
  StockTakeStatus.cancelled: 'cancelled',
};

StockTakeItemModel _$StockTakeItemModelFromJson(Map<String, dynamic> json) =>
    StockTakeItemModel(
      id: json['id'] as String,
      stockTakeId: json['stockTakeId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      productCode: json['productCode'] as String,
      systemQuantity: (json['systemQuantity'] as num).toInt(),
      countedQuantity: (json['countedQuantity'] as num?)?.toInt(),
      countMethod: $enumDecodeNullable(
        _$CountMethodEnumMap,
        json['countMethod'],
      ),
      countedBy: json['countedBy'] as String?,
      countedAt: json['countedAt'] == null
          ? null
          : DateTime.parse(json['countedAt'] as String),
      notes: json['notes'] as String?,
      photoUrls: (json['photoUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$StockTakeItemModelToJson(StockTakeItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'stockTakeId': instance.stockTakeId,
      'productId': instance.productId,
      'productName': instance.productName,
      'productCode': instance.productCode,
      'systemQuantity': instance.systemQuantity,
      'countedQuantity': instance.countedQuantity,
      'countMethod': _$CountMethodEnumMap[instance.countMethod],
      'countedBy': instance.countedBy,
      'countedAt': instance.countedAt?.toIso8601String(),
      'notes': instance.notes,
      'photoUrls': instance.photoUrls,
      'metadata': instance.metadata,
    };

const _$CountMethodEnumMap = {
  CountMethod.manual: 'manual',
  CountMethod.barcode: 'barcode',
  CountMethod.photo: 'photo',
};
