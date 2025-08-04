// lib/data/models/production/scrap_record_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/production/scrap_record.dart';
import '../../../domain/entities/scrap_record.dart';

part 'scrap_record_model.g.dart';

@JsonSerializable()
class ScrapRecordModel extends Equatable {
  final String productionOrderId;
  final String rawMaterialId;
  final int wastedQuantity;
  final String reason;

  const ScrapRecordModel({
    required this.productionOrderId,
    required this.rawMaterialId,
    required this.wastedQuantity,
    required this.reason,
  });

  factory ScrapRecordModel.fromJson(Map<String, dynamic> json) =>
      _$ScrapRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScrapRecordModelToJson(this);

  ScrapRecord toDomain() => ScrapRecord(
    productionOrderId: productionOrderId,
    rawMaterialId: rawMaterialId,
    wastedQuantity: wastedQuantity,
    reason: reason,
  );

  static ScrapRecordModel fromDomain(ScrapRecord e) => ScrapRecordModel(
    productionOrderId: e.productionOrderId,
    rawMaterialId: e.rawMaterialId,
    wastedQuantity: e.wastedQuantity,
    reason: e.reason,
  );

  ScrapRecordModel copyWith({
    String? productionOrderId,
    String? rawMaterialId,
    int? wastedQuantity,
    String? reason,
  }) {
    return ScrapRecordModel(
      productionOrderId: productionOrderId ?? this.productionOrderId,
      rawMaterialId: rawMaterialId ?? this.rawMaterialId,
      wastedQuantity: wastedQuantity ?? this.wastedQuantity,
      reason: reason ?? this.reason,
    );
  }

  @override
  List<Object?> get props => [
    productionOrderId,
    rawMaterialId,
    wastedQuantity,
    reason,
  ];
}
