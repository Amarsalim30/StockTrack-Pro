import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/catalog//product.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel extends Equatable {
  final String id;
  final String name;
  final String sku;
  final String? description;
  final String categoryId;
  final String supplierId;
  final double? price;
  final double? costPrice;
  final List<String>? tags;

  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    this.description,
    required this.categoryId,
    required this.supplierId,
    this.price,
    this.costPrice,
    this.tags,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  Product toDomain() =>
      Product(
        id: id,
        name: name,
        sku: sku,
        description: description,
        categoryId: categoryId,
        supplierId: supplierId,
        price: price,
        costPrice: costPrice,
        tags: tags,
      );

  static ProductModel fromDomain(Product ent) =>
      ProductModel(
        id: ent.id,
        name: ent.name,
        sku: ent.sku,
        description: ent.description,
        categoryId: ent.categoryId,
        supplierId: ent.supplierId,
        price: ent.price,
        costPrice: ent.costPrice,
        tags: ent.tags,
      );

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? description,
    String? categoryId,
    String? supplierId,
    double? price,
    double? costPrice,
    List<String>? tags,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props =>
      [
        id,
        name,
        sku,
        description,
        categoryId,
        supplierId,
        price,
        costPrice,
        tags
      ];
}
