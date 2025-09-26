import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/catalog/product.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel extends Equatable {
  final String id;
  final String name;
  final String sku;
  final String? description;
  final String categoryId;
  final String supplierId;
  final String? unitId;
  final double? price;
  final double? costPrice;
  final List<String>? tags;
  final bool isActive;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    this.description,
    required this.categoryId,
    required this.supplierId,
    this.unitId,
    this.price,
    this.costPrice,
    this.tags,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  /// Convert to domain entity
  Product toDomain() => Product(
        id: id,
        name: name,
        sku: sku,
        description: description,
        categoryId: categoryId,
        supplierId: supplierId,
        unitId: unitId,
        price: price,
        costPrice: costPrice,
        tags: tags,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  /// Create from domain entity
  static ProductModel fromDomain(Product entity) => ProductModel(
        id: entity.id,
        name: entity.name,
        sku: entity.sku,
        description: entity.description,
        categoryId: entity.categoryId,
        supplierId: entity.supplierId,
        unitId: entity.unitId,
        price: entity.price,
        costPrice: entity.costPrice,
        tags: entity.tags,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  /// Create model for Firebase creation (without id and timestamps)
  ProductModel forCreation() => copyWith(
        id: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  /// Create model for Firebase update (with updated timestamp)
  ProductModel forUpdate() => copyWith(
        updatedAt: DateTime.now(),
      );

  ProductModel copyWith({
    String? id,
    String? name,
    String? sku,
    String? description,
    String? categoryId,
    String? supplierId,
    String? unitId,
    double? price,
    double? costPrice,
    List<String>? tags,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      supplierId: supplierId ?? this.supplierId,
      unitId: unitId ?? this.unitId,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        sku,
        description,
        categoryId,
        supplierId,
        unitId,
        price,
        costPrice,
        tags,
        isActive,
        createdAt,
        updatedAt,
      ];
}
