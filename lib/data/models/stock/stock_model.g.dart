// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
  id: json['id'] as String,
  name: json['name'] as String,
  sku: json['sku'] as String,
  quantity: (json['quantity'] as num).toInt(),
  status: $enumDecode(_$StockStatusEnumMap, json['status']),
  durabilityType: $enumDecode(
    _$StockDurabilityTypeEnumMap,
    json['durabilityType'],
  ),
  description: json['description'] as String?,
  categoryId: json['categoryId'] as String?,
  supplierId: json['supplierId'] as String?,
  unit: json['unit'] as String?,
  location: json['location'] as String?,
  minimumStock: (json['minimumStock'] as num?)?.toInt(),
  maximumStock: (json['maximumStock'] as num?)?.toInt(),
  averageDailyUsage: (json['averageDailyUsage'] as num?)?.toInt(),
  leadTimeDays: (json['leadTimeDays'] as num?)?.toInt(),
  safetyStock: (json['safetyStock'] as num?)?.toInt(),
  reorderPoint: (json['reorderPoint'] as num?)?.toInt(),
  preferredReorderQuantity: (json['preferredReorderQuantity'] as num?)?.toInt(),
  price: (json['price'] as num?)?.toDouble(),
  costPrice: (json['costPrice'] as num?)?.toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  lastSoldDate: json['lastSoldDate'] == null
      ? null
      : DateTime.parse(json['lastSoldDate'] as String),
  deadstockThreshold: StockModel._durFromJson(
    (json['deadstockThreshold'] as num?)?.toInt(),
  ),
  warehouseStock: (json['warehouseStock'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  movementHistory: StockModel._movementHistoryFromJson(
    json['movementHistory'] as List?,
  ),
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sku': instance.sku,
      'quantity': instance.quantity,
      'status': _$StockStatusEnumMap[instance.status]!,
      'durabilityType': _$StockDurabilityTypeEnumMap[instance.durabilityType]!,
      'description': instance.description,
      'categoryId': instance.categoryId,
      'supplierId': instance.supplierId,
      'unit': instance.unit,
      'location': instance.location,
      'minimumStock': instance.minimumStock,
      'maximumStock': instance.maximumStock,
      'averageDailyUsage': instance.averageDailyUsage,
      'leadTimeDays': instance.leadTimeDays,
      'safetyStock': instance.safetyStock,
      'reorderPoint': instance.reorderPoint,
      'preferredReorderQuantity': instance.preferredReorderQuantity,
      'price': instance.price,
      'costPrice': instance.costPrice,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'lastSoldDate': instance.lastSoldDate?.toIso8601String(),
      'deadstockThreshold': StockModel._durToJson(instance.deadstockThreshold),
      'warehouseStock': instance.warehouseStock,
      'movementHistory': StockModel._movementHistoryToJson(
        instance.movementHistory,
      ),
      'tags': instance.tags,
    };

const _$StockStatusEnumMap = {
  StockStatus.lowStock: 'lowStock',
  StockStatus.outOfStock: 'outOfStock',
  StockStatus.reserved: 'reserved',
  StockStatus.damaged: 'damaged',
  StockStatus.expired: 'expired',
  StockStatus.inTransit: 'inTransit',
  StockStatus.inStock: 'inStock',
  StockStatus.discontinued: 'discontinued',
};

const _$StockDurabilityTypeEnumMap = {
  StockDurabilityType.perishable: 'perishable',
  StockDurabilityType.nonPerishable: 'nonPerishable',
  StockDurabilityType.durable: 'durable',
  StockDurabilityType.consumable: 'consumable',
};
