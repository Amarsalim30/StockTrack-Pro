// lib/data/models/catalog/bill_of_materials_model.dart

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/catalog/bill_of_material.dart';
import 'bom_item_model.dart';

part 'bill_of_material_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BillOfMaterialsModel extends Equatable {
  final String productId;
  final List<BomItemModel> components;
  final int yieldPerRun;
  final double scrapPercent;

  const BillOfMaterialsModel({
    required this.productId,
    required this.components,
    this.yieldPerRun = 1,
    this.scrapPercent = 0.0,
  });

  factory BillOfMaterialsModel.fromJson(Map<String, dynamic> json) =>
      _$BillOfMaterialsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BillOfMaterialsModelToJson(this);

  BillOfMaterials toDomain() => BillOfMaterials(
    productId: productId,
    components: components.map((m) => m.toDomain()).toList(),
    yieldPerRun: yieldPerRun,
    scrapPercent: scrapPercent,
  );

  static BillOfMaterialsModel fromDomain(BillOfMaterials e) =>
      BillOfMaterialsModel(
        productId: e.productId,
        components: e.components.map(BomItemModel.fromDomain).toList(),
        yieldPerRun: e.yieldPerRun,
        scrapPercent: e.scrapPercent,
      );

  @override
  List<Object?> get props => [productId, components, yieldPerRun, scrapPercent];
}
