import 'package:equatable/equatable.dart';

class Product extends Equatable {
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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Product({
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

  // Business logic methods
  bool get hasValidPrice => price != null && price! > 0;
  bool get hasCostPrice => costPrice != null && costPrice! > 0;
  double get profitMargin => hasValidPrice && hasCostPrice
      ? ((price! - costPrice!) / costPrice!) * 100
      : 0.0;

  Product copyWith({
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
    return Product(
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
